Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbZCMRLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbZCMRLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760660AbZCMRGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:06:16 -0400
Received: from alcalazamora.dti2.net ([81.24.162.8]:3680 "EHLO
	alcalazamora.dti2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759554AbZCMRGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:06:14 -0400
X-Spam-Processed: alcalazamora.dti2.net, Fri, 13 Mar 2009 18:06:11 +0100
	(not processed: message from valid local sender)
X-MDOP-RefID: str=0001.0A0B0206.49BA9280.0287,ss=1,fgs=0 (_st=1 _vt=0 _iwf=0)
X-Authenticated-Sender: jorge@dti2.net
X-MDRemoteIP: 81.24.161.20
X-Return-Path: jorge@dti2.net
X-Envelope-From: jorge@dti2.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <49BA927F.8020701@dti2.net>
Date: Fri, 13 Mar 2009 18:06:07 +0100
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: npiggin@suse.de
CC: ext-adrian.hunter@nokia.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
References: <20090228055809.GC28496@wotan.suse.de> <49AC1A7A.1070108@dti2.net> <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net> <20090305094623.GA17815@wotan.suse.de> <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de> <49B69A09.3080408@dti2.net> <20090311021920.GA16561@wotan.suse.de>
In-Reply-To: <20090311021920.GA16561@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Reply-To: jorge@dti2.net
X-MDAV-Processed: alcalazamora.dti2.net, Fri, 13 Mar 2009 18:06:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin escribió:
> On Tue, Mar 10, 2009 at 05:49:13PM +0100, Jorge Boncompte [DTI2] wrote:
>> Nick Piggin escribió:
>>> Ah, of course, it would be due to directory-in-pagecache. You need
>>> the following patch if you expect this to work.
>>>
>>> And that confirms the ext3 problem is a different one because it
>>> doesn't use directory in pagecache I think. Well, I'll look at
>>> that one tomorrow.
>>>
>>> Thanks,
>>> Nick
>>>
>>> ---
>>> fs/super.c |    2 ++
>>> 1 file changed, 2 insertions(+)
>>>
>>> Index: linux-2.6/fs/super.c
>>> ===================================================================
>>> --- linux-2.6.orig/fs/super.c
>>> +++ linux-2.6/fs/super.c
>>> @@ -644,6 +644,8 @@ int do_remount_sb(struct super_block *sb
>>> 		acct_auto_close(sb);
>>> 	shrink_dcache_sb(sb);
>>> 	fsync_super(sb);
>>> +	if (flags & MS_RDONLY)
>>> +		invalidate_bdev(sb->s_bdev);
>>>
>>> 	/* If we are remounting RDONLY and current sb is read/write,
>>> 	   make sure there are no rw files opened */
>>>
>>>
>>>
>>>
>> 	With this applied it seems I cannot reproduce the corruption, I have 
> 
> Ah, that sounds promising.
> 
>> 	to do more tests, but the box oopses on reboot after doing "umount -na -r".
> 
> Oh, silly me, s_bdev will be NULL for non block device based filesystems.
> If you check for s_bdev != NULL there too, it should work.

	Hi Nick, no problems noticed in the last days running with the below 
patch...

--- linux-2.6.29-rc8/fs/super.c       2009-03-13 13:46:19 +0100
+++ kernel/fs/super.c       2009-03-13 13:47:50 +0100
@@ -647,6 +647,8 @@ int do_remount_sb(struct super_block *sb
                 acct_auto_close(sb);
         shrink_dcache_sb(sb);
         fsync_super(sb);
+       if (sb->s_bdev && (flags & MS_RDONLY))
+               invalidate_bdev(sb->s_bdev);

         /* If we are remounting RDONLY and current sb is read/write,
            make sure there are no rw files opened */

-- 
==============================================================
Jorge Boncompte - Ingenieria y Gestion de RED
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be made.
==============================================================

