Return-Path: <linux-kernel-owner+w=401wt.eu-S1161079AbXBTXqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079AbXBTXqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161091AbXBTXqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:46:39 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:36699 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161079AbXBTXqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:46:38 -0500
Date: Wed, 21 Feb 2007 00:45:40 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: securityfs_create_dir strange comment
In-Reply-To: <20070220222652.GB21696@kroah.com>
Message-ID: <Pine.LNX.4.61.0702210042140.7132@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr>
 <20070220211849.GA3416@vino.hallyn.com> <20070220222652.GB21696@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20 2007 14:26, Greg KH wrote:
>On Tue, Feb 20, 2007 at 03:18:49PM -0600, Serge E. Hallyn wrote:
>> Quoting Jan Engelhardt (jengelh@linux01.gwdg.de):
>> > Hello list,
>> > 
>> > 
>> > in security/inode.c, the comment for securityfs_create_dir() reads:
>> > 
>> > 	If securityfs is not enabled in the kernel, the value -ENODEV 
>> > 	will be returned.  It is not wise to check for this value, but 
>> > 	rather, check for NULL or !NULL instead as to eliminate the need 
>> > 	for #ifdef in the calling code.
>> > 
>> > What is the actual callee that can return NULL - and what should 
>> > module_init() of a module return when securityfs_create_dir() returns 
>> > NULL?
>> 
>> Hmm, this came from GregKH.  It does seem based on the code that
>> checking for -ENODEV is necessary, so I don't understand the comment.
>
>If securityfs_create_dir() returns NULL, then something bad happened and
>your code needs to properly recover from it.
>
>Other than that, I don't understand the issue here.

Consider:

static __init int mymodule_init(void)
{
    struct dentry *de;
    de = securityfs_create_dir("foobar", NULL);

    /* case 1 */
    if(IS_ERR(de))
        return PTR_ERR(de);

    /* case 2 */
    if(de == NULL)
        return WHAT_HERE; /* -EIO? */
}

There are two error cases. One: when the function gives us an error code.
Two: When it returns NULL, without an error code. This looks bogus to me.
What error is it, when there is no error? - And what should I return to
modprobe in that case?


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
