Return-Path: <linux-kernel-owner+w=401wt.eu-S935145AbYAaWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935145AbYAaWP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbYAaWL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:11:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54890 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934748AbYAaWLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:11:25 -0500
Message-ID: <47A24765.3070300@zytor.com>
Date: Thu, 31 Jan 2008 14:10:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk> <1201815920-24669-2-git-send-email-ijc@hellion.org.uk> <1201815920-24669-3-git-send-email-ijc@hellion.org.uk>
In-Reply-To: <1201815920-24669-3-git-send-email-ijc@hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  Documentation/i386/boot.txt |    5 +++
>  arch/x86/boot/tools/build.c |   78 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
> index b5f5ba1..ad201f0 100644
> --- a/Documentation/i386/boot.txt
> +++ b/Documentation/i386/boot.txt
> @@ -531,6 +531,11 @@ Protocol:	2.08+
>  
>    The length of the compressed payload.
>  
> +**** THE IMAGE CHECKSUM
> +
> +The CRC-32 checksum of the entire file is appended to the end of the
> +file. The CRC of the file including these trailing bytes is therefore 0.
> +

Hm.  I have some minor concerns about this:

* The classical length field is only available in multiples of 16 (I 
realize your patches change that to some degree, but I'd hate to make 
the guarantee that the image payload is the last thing in the image -- 
it loses flexibility for the future.)  The end of the image isn't 
available in all cases, so this would require padding it out to a 
16-byte boundary before appending the CRC32.  An mmap is guaranteed to 
be zero-padded out to the next page boundary, so explicitly rounding sz 
up (instead of when calculating sys_size) should do the job.

* I believe it is recommended to store the inverse of the crc32, not the 
crc32 itself - it catches more errors.  This is also the reason to start 
out with ~0 rather than 0.

* Please don't use "unsigned long" to represent a 32-bit number.

	-hpa

