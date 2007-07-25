Return-Path: <linux-kernel-owner+w=401wt.eu-S933240AbXGYPaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbXGYPaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763633AbXGYPaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:30:08 -0400
Received: from seanodes.co.fr.clara.net ([212.43.220.11]:50745 "EHLO
	seanodes.co.fr.clara.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762617AbXGYPaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:30:06 -0400
Date: Wed, 25 Jul 2007 17:29:56 +0200
From: Alban Crequy <alban.crequy@seanodes.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] error management in add_disk()
Message-ID: <20070725172956.2fa5b63e@alban>
In-Reply-To: <20070724132805.GR21668@ftp.linux.org.uk>
References: <20070724135753.18fccf4f@alban>
	<20070724132805.GR21668@ftp.linux.org.uk>
Organization: Seanodes
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 24 Jul 2007 14:28:05 +0100,
Al Viro <viro@ftp.linux.org.uk> a écrit :

>On Tue, Jul 24, 2007 at 01:57:53PM +0200, Alban Crequy wrote:
>> Hi,
>> 
>> I have a problem with the error management of add_disk() and
>> del_gendisk().
>> 
>> add_disk() adds an entry in /sys/block/<name>. The filename
>> in /sys/block is not (struct gen_disk)->disk_name but more or less
>> the first KOBJ_NAME_LEN characters of (struct gen_disk)->disk_name.
>> 
>> #define KOBJ_NAME_LEN                   20
>> 
>> My problem occurs when we try to add 2 disks with different names,
>> but when the KOBJ_NAME_LEN first characters are the same.
>
>So don't do that.

I no more do that. But I still think it would be better if we found a
way to manage errors in that case.

I fear that parts of kernel make this error. For example, old version of
GFS has this code:

http://csourcesearch.net/package/gfs-kernel/2.6.9/gfs-kernel-2.6.9-27/src/gfs/diaper.c
  char buf[BDEVNAME_SIZE];
  bdevname(real, buf);
  snprintf(gd->disk_name, sizeof(gd->disk_name), "diapered_%s", buf);

Since BDEVNAME_SIZE is 32 and KOBJ_NAME_LEN is 20, the bug happens quite
easily.

I did not check closely if this is a problem, but there is other parts
in the current kernel that build the disk_name with snprintf("...%s...")

>> The attached test module triggers the problem. You can try something
>> like: for i in $(seq 1 100) ; do insmod ./adddiskbug.ko ; rmmod
>> adddiskbug ; done
>> 
>> The attached patch fixes the problem by changing the prototype of
>> add_disk() and register_disk() to return errors.
> 
>This is bogus.  Just what would callers do with these error values?
>Ignore them silently?  Bail out?  Can't do - at that point disk just
>might have been opened already.  add_disk() is the point of no return;
>we are already past the last point where we could bail out.

I missed that point - that the disk might have been opened.  Where is
the point of no return in add_disk() exactly?  Is it really before the
kobject_add() that causes the problem?

In this case, perhaps we can 1/ check that the kobject_add() will not
fail before the point of no return, 2/ pass this point and then 3/ do
the kobject_add(). And add appropriate locking to ensure that nobody
add another disk with the same 20-characters truncated name between 1/
and 3/.

