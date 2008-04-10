Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYDJN4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYDJN4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 09:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYDJN4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 09:56:05 -0400
Received: from styx.suse.cz ([82.119.242.94]:49587 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755248AbYDJN4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:56:03 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: file offset corruption on 32-bit machines?
Date: Thu, 10 Apr 2008 15:55:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804101555.58643.mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding fsdevel list]

On Tuesday 08 April 2008 10:05:47 am Meelis Roos wrote:
> Jeff Robertson analyzes the behaviour of different operating systems'
> 64-bit file offset implementation and concludes that on 32-bit
> machines, Linux and Solaris lack any locking to keep the two 32-bit
> halves in sync and this could cause rare file offset corruption.
>
> http://jeffr-tech.livejournal.com/21014.html

AFAICS, this race is theoretically possible, but it is very hard (almost 
impossible) to trigger with a sane file usage pattern. 
Note that you have to access shared struct file (same file descriptor) in 
different threads which should be synchronized by caller anyway (*).

I also don't see any security implications from this race, but maybe someone 
with more knowlage about fs can see (f_pos is used at many places in the 
kernel code).

I think that it is better to live with tiny-race-on-broken-patterns rather 
than paying for synchronization which is not needed for correct paths. 

[*] file_pos_{read,write} (fs/read_write.c) are not called under lock (in 
sys_read, sys_write, ...), so even if f_pos is written atomically, you will 
be able to get races when accessing shared descriptor from different threads.
I think that POSIX states, that behavior is undefined under these conditions.

Best regards
-- 
Michal Hocko
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic 
