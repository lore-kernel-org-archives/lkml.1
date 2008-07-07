Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYGGNVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYGGNVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYGGNVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:21:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:53204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752824AbYGGNVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:21:39 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX1/z0IIAdKDzEOCLcri5uTN7bWp4EUq5HHq2VBjaqy
	T2gCb9THAi79tL
Message-ID: <48721860.1010800@gmx.net>
Date: Mon, 07 Jul 2008 15:21:36 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080316 SUSE/1.1.9-1.1 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Anton Altaparmakov <aia21@cam.ac.uk>
CC: Eric Sesterhenn <snakebyte@gmx.de>, linux-ntfs-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-NTFS-Dev] Oops with corrupted NTFS image
References: <20080706172147.GA19559@alice> <F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>
In-Reply-To: <F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.07.2008 10:07, Anton Altaparmakov wrote:
> Hi,
>
> Thanks for the report.  Would you be able to try the below change to  
> your kernel and repeat?
>
> On 6 Jul 2008, at 18:21, Eric Sesterhenn wrote:
>   
>> 0xc030ad5c is in ntfs_read_locked_inode (fs/ntfs/time.h:95).
>> 90		u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
>> 91		/*
>> 92		 * Convert the time to 1-second intervals and the remainder to
>> 93		 * 1-nano-second intervals.
>> 94		 */
>> 95		ts.tv_nsec = do_div(t, 10000000) * 100;
>> 96		ts.tv_sec = t;
>> 97		return ts;
>> 98	}
>>     
>
> Please replace the ts.tv_nsec=... and ts.tv_sec=... with:
>
> 		if (t) {
> 			ts.tv_nsec = do_div(t, 10000000) * 100;
> 			ts.tv_sec = t;
> 		} else {
> 			ts.tv_nsec = 0;
> 			ts.tv_sec = 0;
> 		}
>   

AFAICS it is not the division that fails (unless a division itself can
cause an access to invalid memory), but either the write to ts or the
read from t. Dependign on compiler optimizations, the real root cause
may be related to an access to time.

Regards,
Carl-Daniel

-- 
http://www.hailfinger.org/

