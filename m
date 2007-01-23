Return-Path: <linux-kernel-owner+w=401wt.eu-S965434AbXAWTAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434AbXAWTAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965436AbXAWTAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:00:48 -0500
Received: from BACHE.ECE.CMU.EDU ([128.2.129.23]:45607 "EHLO bache.ece.cmu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965435AbXAWTAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:00:47 -0500
X-Greylist: delayed 1367 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 14:00:47 EST
Message-ID: <45B65606.1090402@cmu.edu>
Date: Tue, 23 Jan 2007 13:37:58 -0500
From: "Jonathan M. McCune" <jonmccune@cmu.edu>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: reading a binary sysfs attribute continues forever
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have written a kernel module which introduces a new subsystem in
sysfs, and it contains several attributes, one of which is binary.  So
far, I've been testing it using text.  My problem is, attempting to read
data continues forever.  For example:

# echo "test data" > /sys/mystuff/binaryattrib
# cat /sys/mystuff/binaryattrib

test data
test data
test data
test data
test data
test data
test data
test data
test data
test data
test data
test data
... and so on forever.

Here are the read and write functions for the binary attribute:
'void *input_params' is a pointer to PAGE_SIZE (4096 for me) bytes, and
'size_t input_params_size' contains the actual number of bytes which
were written  to input_params by the _write function.  input_params_size
is initialized to zero when the module is first loaded.

static ssize_t binaryattrib_read(struct kobject *kobj, char *buf, loff_t
pos,
                           size_t count) {

    if(input_params_size + sizeof(size_t) > count)
        return -EINVAL;

    memcpy(buf, (void *)&input_params_size, sizeof(size_t));
    memcpy(buf+sizeof(size_t), input_params, input_params_size);

    return input_params_size + sizeof(size_t);
}

static ssize_t binaryattrib_write(struct kobject *kobj, char *buf,
loff_t pos,
                              size_t count)
{
        memset(input_params, 0, PAGE_SIZE);

        if ((pos + count) > PAGE_SIZE)
                return -EINVAL;

        memcpy(input_params+pos, buf, count);
        input_params_size = count;

        return count;
}

If binaryattrib_read() returns 0, the userspace program reads no data.
If it returns any positive number, the userspace program reads forever.
 If it returns a negative number, that is interpreted as an error.

I am at a loss.  Is it the case that the userspace program should be
responsible enough to read the size out of the first 4 bytes of data (as
I have included above) and simply stop reading once it gets everything?

The documentation I have been able to find (mostly
http://lwn.net/Articles/54651/ and slight variants of it) suggests that
writes work in this way, in that the _write function will be called
arbitrarily many times with PAGE_SIZE or smaller chunks, and it is up to
the kernel module to determine when all the data has arrived.

Thank you to anyone who can offer me some insight!
-Jon
