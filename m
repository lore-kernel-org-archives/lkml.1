Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbXEFOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbXEFOXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 10:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXEFOXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 10:23:39 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3926 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbXEFOXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 10:23:38 -0400
Date: Sun, 6 May 2007 15:23:29 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: LED stuff - why bother with error handling
Message-ID: <20070506142329.GA21158@flint.arm.linux.org.uk>
Mail-Followup-To: Linux Kernel List <linux-kernel@vger.kernel.org>,
	Richard Purdie <rpurdie@rpsys.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While reviewing 4359/2, I found the following issue.  Let's remove all
the irrelevant lines of code to illustrate the problem.

void led_trigger_register_simple(const char *name, struct led_trigger **tp)
{
        struct led_trigger *trigger;

        trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
...
        *tp = trigger;
}

void led_trigger_unregister(struct led_trigger *trigger)
{
        list_del(&trigger->next_trig);
}

The thing to note is that led_trigger_register_simple() can fail but it's
a void function.  There's a very good school of thought which says that
functions which can fail should never have a return type of void.

However, let's continue.  Looking at patch 4359/2 in the ARM patch
system:

+static int __init h1940bt_probe(struct platform_device *pdev)
+{
...
+#ifdef CONFIG_LEDS_H1940
+	led_trigger_register_simple("h1940-bluetooth", &bt_led_trigger);
+#endif
+	err = device_create_file(&pdev->dev, &dev_attr_enable);
+
+	return err;
+}
+
+static int h1940bt_remove(struct platform_device *pdev)
+{
+#ifdef CONFIG_LEDS_H1940
+	led_trigger_unregister_simple(bt_led_trigger);
+#endif
+	return 0;
+}

Notice the lack of checking to see if bt_led_trigger is NULL or not - if
the kzalloc fails, we happily return success from the probe function.
However, when the driver is removed, we call led_trigger_unregister_simple()
which consequently does a NULL dereference.

This seems to be an endemic problem to led_trigger_register_simple() - 100%
of the merged uses of this function suffer from the same issue, eg:

static int __init ledtrig_ide_init(void)
{
        led_trigger_register_simple("ide-disk", &ledtrig_ide);
        return 0;
}

static void __exit ledtrig_ide_exit(void)
{
        led_trigger_unregister_simple(ledtrig_ide);
}

See also nand_base_init and sharpsl_pm_probe.

If we want people to detect errors then we must *not* return values by
reference.  It stops people thinking about "what if this returns a non-
zero error value" or "what if it returns NULL?".  Adding __must_check
gives extra persuasion to check the return value.

Can the LED trigger API be fixed please?

I'm not going to merge 4359/2 because it's just going to spread this
problem over a wider area.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
