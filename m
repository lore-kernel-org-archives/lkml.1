Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXB0Qwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXB0Qwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXB0Qwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:52:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33749 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXB0Qwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:52:33 -0500
Message-ID: <45E461D4.6050807@us.ibm.com>
Date: Tue, 27 Feb 2007 10:52:36 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Mike Perks <mperks@us.ibm.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
 patch
References: <1172102523.5233.31.camel@dyn9047021078.beaverton.ibm.com> <200702270051.00393.arnd@arndb.de>
In-Reply-To: <200702270051.00393.arnd@arndb.de>
Content-Type: multipart/mixed;
 boundary="------------030502020404010505020204"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030502020404010505020204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have applied the "cleanup" patch that Arnd sent, but had to fix up a 
few things:
   -  Bug fix:  Initialize retval in spu_task_sync.c, line 95, otherwise 
OProfile this function returns non-zero and OProfile fails.
   -  Remove unused codes in include/linux/oprofile.h
   -  Compile warnings:  Initialize offset and spu_cookie at lines 283 
and 284 in spu_task_sync.c

With these changes and some userspace changes that were necessary to 
correspond with Arnd's changes, our testing was successful.

A fixup patch is attached.

P.S.  We have a single patch with all these changes applied if anyone 
would like us to post it.

-Maynard


Arnd Bergmann wrote:

>On Thursday 22 February 2007, Carl Love wrote:
>  
>
>>This patch updates the existing arch/powerpc/oprofile/op_model_cell.c
>>to add in the SPU profiling capabilities.  In addition, a 'cell' subdirectory
>>was added to arch/powerpc/oprofile to hold Cell-specific SPU profiling
>>code.
>>    
>>
>
>There was a significant amount of whitespace breakage in this patch,
>which I cleaned up. The patch below consists of the other things
>I changed as a further cleanup. Note that I changed the format
>of the context switch record, which I found too complicated, as
>I described on IRC last week.
>
>	Arnd <><
>
>  
>


--------------030502020404010505020204
Content-Type: text/x-diff;
 name="fixups-to-arnd-oprof_spu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fixups-to-arnd-oprof_spu.patch"

diff -paur linux-orig/arch/powerpc/oprofile/cell/spu_task_sync.c linux-new/arch/powerpc/oprofile/cell/spu_task_sync.c
--- linux-orig/arch/powerpc/oprofile/cell/spu_task_sync.c	2007-02-27 17:10:24.000000000 -0600
+++ linux-new/arch/powerpc/oprofile/cell/spu_task_sync.c	2007-02-27 17:08:57.000000000 -0600
@@ -92,7 +92,7 @@ prepare_cached_spu_info(struct spu * spu
 {
 	unsigned long flags;
 	struct vma_to_fileoffset_map * new_map;
-	int retval;
+	int retval = 0;
 	struct cached_info * info;
 
         /* We won't bother getting cache_lock here since
@@ -280,8 +280,8 @@ static int process_context_switch(struct
 {
 	unsigned long flags;
 	int retval;
-	unsigned int offset;
-	unsigned long spu_cookie, app_dcookie;
+	unsigned int offset = 0;
+	unsigned long spu_cookie = 0, app_dcookie;
 	retval = prepare_cached_spu_info(spu, objectId);
 	if (retval)
 		goto out;
diff -paur linux-orig/include/linux/oprofile.h linux-new/include/linux/oprofile.h
--- linux-orig/include/linux/oprofile.h	2007-02-27 14:41:29.000000000 -0600
+++ linux-new/include/linux/oprofile.h	2007-02-27 14:43:18.000000000 -0600
@@ -36,9 +36,6 @@
 #define XEN_ENTER_SWITCH_CODE          10
 #define SPU_PROFILING_CODE             11
 #define SPU_CTX_SWITCH_CODE            12
-#define SPU_OFFSET_CODE                13
-#define SPU_COOKIE_CODE                14
-#define SPU_SHLIB_COOKIE_CODE          15
 
 struct super_block;
 struct dentry;

--------------030502020404010505020204--

