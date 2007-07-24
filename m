Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbXGXN2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbXGXN2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXGXN2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:28:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57213 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXGXN2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:28:07 -0400
Date: Tue, 24 Jul 2007 14:28:05 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alban Crequy <alban.crequy@seanodes.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] error management in add_disk()
Message-ID: <20070724132805.GR21668@ftp.linux.org.uk>
References: <20070724135753.18fccf4f@alban>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724135753.18fccf4f@alban>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 01:57:53PM +0200, Alban Crequy wrote:
> Hi,
> 
> I have a problem with the error management of add_disk() and del_gendisk().
> 
> add_disk() adds an entry in /sys/block/<name>. The filename in /sys/block is
> not (struct gen_disk)->disk_name but more or less the first KOBJ_NAME_LEN
> characters of (struct gen_disk)->disk_name.
> 
> #define KOBJ_NAME_LEN                   20
> 
> My problem occurs when we try to add 2 disks with different names, but when
> the KOBJ_NAME_LEN first characters are the same.

So don't do that.

> The attached test module triggers the problem. You can try something like:
> for i in $(seq 1 100) ; do insmod ./adddiskbug.ko ; rmmod adddiskbug ; done
> 
> The attached patch fixes the problem by changing the prototype of add_disk() and
> register_disk() to return errors.
 
This is bogus.  Just what would callers do with these error values?
Ignore them silently?  Bail out?  Can't do - at that point disk just might
have been opened already.  add_disk() is the point of no return; we are
already past the last point where we could bail out.
