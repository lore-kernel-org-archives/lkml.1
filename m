Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXAYANH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXAYANH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932968AbXAYANG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:13:06 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:22214 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbXAYANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:13:05 -0500
Date: Wed, 24 Jan 2007 18:12:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: reading a binary sysfs attribute continues forever
In-reply-to: <fa.uWrqVGz9Bu85mnRCc+6sYuYueiQ@ifi.uio.no>
To: linux-kernel@vger.kernel.org
Cc: "Jonathan M. McCune" <jonmccune@cmu.edu>
Message-id: <45B7F600.1040906@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.uWrqVGz9Bu85mnRCc+6sYuYueiQ@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan M. McCune wrote:
> Hello,
> 
> I have written a kernel module which introduces a new subsystem in
> sysfs, and it contains several attributes, one of which is binary.  So
> far, I've been testing it using text.  My problem is, attempting to read
> data continues forever.  For example:
> 
> # echo "test data" > /sys/mystuff/binaryattrib
> # cat /sys/mystuff/binaryattrib
> 
> test data
> test data
> test data
> test data
> test data
> test data
> test data
> test data
> test data
> test data
> test data
> test data
> .. and so on forever.
> 
> Here are the read and write functions for the binary attribute:
> 'void *input_params' is a pointer to PAGE_SIZE (4096 for me) bytes, and
> 'size_t input_params_size' contains the actual number of bytes which
> were written  to input_params by the _write function.  input_params_size
> is initialized to zero when the module is first loaded.
> 
> static ssize_t binaryattrib_read(struct kobject *kobj, char *buf, loff_t
> pos,
>                            size_t count) {
> 
>     if(input_params_size + sizeof(size_t) > count)
>         return -EINVAL;
> 
>     memcpy(buf, (void *)&input_params_size, sizeof(size_t));
>     memcpy(buf+sizeof(size_t), input_params, input_params_size);
> 
>     return input_params_size + sizeof(size_t);

I don't know sysfs functions well but this looks wrong, you're ignoring 
the pos argument completely and always returning the same data. You 
should be copying the data starting at pos and returning only the number 
of bytes available from that point (possibly zero). Otherwise the user 
app will never get an end of file since more data is always available.

Also, you shouldn't be returning EINVAL if they try to read less than 
the size of your data as that is acceptable behavior and will work fine 
if you handle the pos argument properly.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

