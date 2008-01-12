Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbYALKvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbYALKvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 05:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYALKva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 05:51:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58792 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbYALKv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 05:51:29 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47889B68.8010601@s5r6.in-berlin.de>
Date: Sat, 12 Jan 2008 11:50:16 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Greg KH <gregkh@suse.de>, James.Bottomley@hansenpartnership.com,
       a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       krh@redhat.com, stern@rowland.harvard.edu, dwmw2@infradead.org,
       davem@davemloft.net, jarkao2@gmail.com
Subject: Re: [PATCH 1/7] driver-core : add class iteration api
References: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080112094754.GA2893@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> Add the following class iteration functions for driver use:

Thanks Dave.  I will check the ieee1394 part in detail later.

...
> +/**
> + * class_find_device - device iterator for locating a particular device
> + * @class: the class we're iterating
> + * @data: data for the match function
> + * @match: function to check device
> + *
> + * This is similar to the class_for_each_dev() function above, but it
> + * returns a reference to a device that is 'found' for later use, as
> + * determined by the @match callback.

Maybe add "Drop the reference with put_device() after use." for the
really slow driver programmers like me?

> + *
> + * The callback should return 0 if the device doesn't match and non-zero
> + * if it does.  If the callback returns non-zero, this function will
> + * return to the caller and not iterate over any more devices.
> + */
> +struct device *class_find_device(struct class *class, void *data,
> +				   int (*match)(struct device *, void *))
> +{

A general comment on the linux/device.h API (not a direct comment on
your patch):

The match argument in bus_find_device(), driver_find_device(),
device_find_child(), class_find_device(), class_find_child() could be
changed to

	bool (*match)(struct device *, void *)).

Then the semantics are IMO a little bit clearer.  Ditto for the
dr_match_t type and the struct bus_type.match member.

I don't know though whether the churn of doing such a change everywhere
would be justified by the result.


A comment on patch 2/7...6/7:

You can bring most or all of the various __match implementations into a
slightly terser but IMO easy to read form, like this:

 static int __match_ne(struct device *dev, void *data)
 {
 	struct unit_directory *ud;
 	struct node_entry *ne = (struct node_entry *)data;

 	ud = container_of(dev, struct unit_directory, unit_dev);
-	if (ud->ne == ne)
-		return 1;
-	return 0;
+	return ud->ne == ne;
 }

Here it is also easy to see that readability would improve if the return
type was bool rather than int.
-- 
Stefan Richter
-=====-==--- ---= -==--
http://arcgraph.de/sr/
