Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZBAJse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZBAJse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 04:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZBAJsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 04:48:23 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:1470 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752531AbZBAJsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 04:48:22 -0500
Message-ID: <49856FE6.8020601@panasas.com>
Date: Sun, 01 Feb 2009 11:48:22 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Ankit Jain <me@ankitjain.org>,
       viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility
 with legacy xfs ioctls
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de> <20090130171423.f99c88d0.akpm@linux-foundation.org> <200901310248.42820.arnd@arndb.de>
In-Reply-To: <200901310248.42820.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2009 09:48:19.0811 (UTC) FILETIME=[36C93330:01C98452]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Saturday 31 January 2009, Andrew Morton wrote:
>> Is this written in a standard somewhere?  Is it guaranteed?
> 
> Alignment is defined in the architecture psABI documents. 
> Unfortunately, many of them were written before the 'long long'
> type became part of the C standard, so it's not strictly guaranteed.
> AFAICT, the alignment of __u64 on x86 is the same as the alignment
> of 'double' by convention.
> 
> However, the problem is well-understood: x86 is the only one
> that has a problem in 32/64 bit compat mode. m68k has similar
> issues with 16/32 bit integers, but those don't apply here.
> 
>> If some (perhaps non-gcc) compiler were to lay this out differently
>> (perhaps with suitable command-line options) then that's liveable
>> with - as long as the kernel never changes the layout.  Of course
>> it would be better to avoid this if poss.
> 
> If a compiler was using irregular structure alignment, all sorts of
> library interfaces would break. The kernel ABI is only a small part
> of the problem then.
> 
>> The other potential issue with a structure like this is that there's a
>> risk that it will lead us to copy four bytes of uninitialised kernel
>> memory out to userspace.
>>
>> IOW, it seems a generally bad idea to rely upon compiler-added padding
>> for this sort of thing.
> 
> Agreed in general, but the whole point of this particular patch was to
> provide compatibility with an interface that has been part of XFS for
> many years.
> Linux already has a better interface for new users (sys_fallocate), so
> changing the patch would not be helpful and not provide any advantage.
> 
> There is also no leak of uninitialized data here, because this structure
> is only read, never written.
> 
> 	Arnd <><
Arnd Bergmann wrote:
> +struct space_resv {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start;
> +	__s64		l_len;		/* len == 0 means until end of file */
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area			    */
> +};

What about telling the compiler exactly what you said above, just
to be sure we all mean the same thing. (And as documentation for new
comers):

+struct space_resv_64 {
+	__s16		l_type;
+	__s16		l_whence;
+	__u32		reserved;
+	__s64		l_start;
+	__s64		l_len;		/* len == 0 means until end of file */
+	__s32		l_sysid;
+	__u32		l_pid;
+	__s32		l_pad[4];	/* reserve area			    */
+} __packed;

And define another one for x86_32

Boaz
