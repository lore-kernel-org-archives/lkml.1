Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYHINLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYHINLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYHINLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:11:09 -0400
Received: from www17.your-server.de ([213.133.104.17]:42993 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYHINLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:11:07 -0400
Subject: Re: next-20080808: bash: fork: Resource temporarily unavailable
From: Thomas Meyer <thomas@m3y3r.de>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>
In-Reply-To: <14476.1218286327@redhat.com>
References: <1218281190.3155.5.camel@dhcppc0>
	 <1218214935.3146.5.camel@dhcppc0>
	 <alpine.LRH.1.10.0808090747150.29079@tundra.namei.org>
	 <14476.1218286327@redhat.com>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 15:11:13 +0200
Message-Id: <1218287473.3155.13.camel@dhcppc0>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 09.08.2008, 13:52 +0100 schrieb David Howells:
> Thomas Meyer <thomas@m3y3r.de> wrote:
> 
> > > > Beginning with next-20080808 after letting the system run for 5 minutes
> > > > or so, I get an error from the fork call, e.g.:
> > > > 
> > > > "bash: fork: Resource temporarily unavailable"
> 
> I modified your config slightly so that it'd run on my testbox (x86_64
> unfortunately), but that survived LTP and seemed to work okay.  I'll have to
> snag an i386 installation from somewhere, unless James can do me a favour and
> test it on his, if he has one.
> 
> Can you try this please:
> 
> 	cat /proc/slabinfo  | cut -d: -f1 | sort -k 2 -n
> 
> Just to check to see if there's a memory leak.

I'm too lazy to reboot now. But i can give you that from vmcore dump:

crash> kmem -i
              PAGES        TOTAL      PERCENTAGE
 TOTAL MEM  1524251       5.8 GB         ----
      FREE  1343484       5.1 GB   88% of TOTAL MEM
      USED   180767     706.1 MB   11% of TOTAL MEM
    SHARED    19076      74.5 MB    1% of TOTAL MEM
   BUFFERS     3800      14.8 MB    0% of TOTAL MEM
    CACHED   108483     423.8 MB    7% of TOTAL MEM
      SLAB     6239      24.4 MB    0% of TOTAL MEM

TOTAL HIGH  1343440       5.1 GB   88% of TOTAL MEM
 FREE HIGH        0            0    0% of TOTAL HIGH
 TOTAL LOW   180811     706.3 MB   11% of TOTAL MEM
  FREE LOW  1343484       5.1 GB  743% of TOTAL LOW

TOTAL SWAP  1596751       6.1 GB         ----
 SWAP USED        0            0    0% of TOTAL SWAP
 SWAP FREE  1596751       6.1 GB  100% of TOTAL SWAP

Is that what you wanted to know? Doesn't look like a memory leak for me.

kmem -s doesn't seem to work:

crash> kmem -s

kmem: invalid structure member offset: kmem_cache_objects
      FILE: memory.c  LINE: 13500  FUNCTION: dump_kmem_cache_slub()

[/usr/bin/crash] error trace: 8085195 => 809f8cf => 80c0d82 => 813b9a0
CACHE    NAME                 OBJSIZE  ALLOCATED     TOTAL  SLABS  SSIZE

  813b9a0: OFFSET_verify+118
  80c0d82: dump_kmem_cache_slub+1033
  809f8cf: cmd_kmem+3077
  8085195: exec_command+265

kmem: invalid structure member offset: kmem_cache_objects
      FILE: memory.c  LINE: 13500  FUNCTION: dump_kmem_cache_slub()


