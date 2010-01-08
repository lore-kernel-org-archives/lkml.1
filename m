Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445Ab0AHF3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0AHF3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895Ab0AHF3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:29:18 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:2582 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab0AHF3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:29:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=KqUPxcEcVYVCnRpHhsFrSbGJRVw6hs81mDYJDOU0K3MHmAnYsOJcrgs92wXoQLwT+m
         xJWfGZRN9krIpfCJH+AtaMNxZXgxanrdhyBIjFTvLNwbrN+xYu1jV/9WasVe1yZ9MdBa
         6y7hVaELbNDPPsbz8FPR0RqsLKG5dl4Keeuw0=
MIME-Version: 1.0
In-Reply-To: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com>
References: <f17812d71001072114g95c267cpa6dc06a636c6d9a@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 8 Jan 2010 13:28:57 +0800
Message-ID: <f17812d71001072128g63361e74q74cf06ae1e1eb3d6@mail.gmail.com>
Subject: Re: [PATCH] gpio: introduce gpio_request_one() and friends
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo in GPIOF_* definitions, updated patch follows:

commit 29cd35f57699fd93a12132186d52109a55ed57e7
Author: Eric Miao <eric.y.miao@gmail.com>
Date:   Fri Jan 8 12:16:28 2010 +0800

    gpio: introduce gpio_request_one() and friends

    gpio_request() without initial configuration of the GPIO is normally
    useless, introduce gpio_request_one() together with GPIOF_ flags for
    input/output direction and initial output level.

    gpio_{request,free}_array() for multiple GPIOs.

    Cc: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a25ad28..e80a1f8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1239,6 +1239,48 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);

+int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
+{
+	int err;
+
+	err = gpio_request(gpio, label);
+	if (err)
+		return err;
+
+	if (flags & GPIOF_DIR_IN)
+		err = gpio_direction_input(gpio);
+	else
+		err = gpio_direction_output(gpio,
+				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_one);
+
+int gpio_request_array(struct gpio *array, size_t num)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++, array++) {
+		err = gpio_request_one(array->gpio, array->flags, array->label);
+		if (err)
+			goto err_free;
+	}
+	return 0;
+
+err_free:
+	while (i--)
+		gpio_free((--array)->gpio);
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_array);
+
+void gpio_free_array(struct gpio *array, size_t num)
+{
+	while (num--)
+		gpio_free((array++)->gpio);
+}
+EXPORT_SYMBOL_GPL(gpio_free_array);

 /**
  * gpiochip_is_requested - return string iff signal was requested
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 485eeb6..a9e0b94 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -136,6 +136,26 @@ extern int __gpio_cansleep(unsigned gpio);

 extern int __gpio_to_irq(unsigned gpio);

+#define GPIOF_DIR_OUT	(0 << 0)
+#define GPIOF_DIR_IN	(1 << 0)
+
+#define GPIOF_INIT_LOW	(0 << 1)
+#define GPIOF_INIT_HIGH	(1 << 1)
+
+#define GPIOF_IN		(GPIOF_DIR_IN)
+#define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
+#define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
+
+struct gpio {
+	unsigned	gpio;
+	unsigned long	flags;
+	const char	*label;
+};
+
+extern int gpio_request_one(unsigned gpio, unsigned long flags, const
char *label);
+extern int gpio_request_array(struct gpio *array, size_t num);
+extern void gpio_free_array(struct gpio *array, size_t num);
+
 #ifdef CONFIG_GPIO_SYSFS

 /*
