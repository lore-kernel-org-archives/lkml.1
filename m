Return-Path: <linux-kernel-owner+w=401wt.eu-S1762965AbYFLOFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762965AbYFLOFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762862AbYFLOFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:05:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53786 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762048AbYFLOFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:05:11 -0400
Date: Thu, 12 Jun 2008 09:05:09 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       holt@sgi.com, andrea@qumranet.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 00/11] GRU Driver
Message-ID: <20080612140509.GA21437@sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com> <20080612132700.GA18107@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612132700.GA18107@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 03:27:00PM +0200, Ingo Molnar wrote:
> 
> * steiner@sgi.com <steiner@sgi.com> wrote:
> 
> > This series of patches adds a driver for the SGI UV GRU. The driver is 
> > still in development but it currently compiles for both x86_64 & IA64. 
> > All simple regression tests pass on IA64. Although features remain to 
> > be added, I'd like to start the process of getting the driver into the 
> > kernel. Additional kernel drivers will depend on services provide by 
> > the GRU driver.
> > 
> > The GRU is a hardware resource located in the system chipset. The GRU 
> > contains memory that is mmaped into the user address space. This 
> > memory is used to communicate with the GRU to perform functions such 
> > as load/store, scatter/gather, bcopy, AMOs, etc.  The GRU is directly 
> > accessed by user instructions using user virtual addresses. GRU 
> > instructions (ex., bcopy) use user virtual addresses for operands.
> 
> did i get it right that it's basically a fast, hardware based message 
> passing interface that allows two tasks to communicate via DMA and 
> interrupts, without holding up the CPU? 

Yes


> If that is the case, wouldnt the 
> proper support model be a network driver, instead of these special 
> ioctls. (a network driver with no checksumming, with scatter-gather, 
> zero-copy and TSO support, etc.)
> 
> or a filesystem. Anything but special-purpose ioctls ...

The ioctls are not used directly by users.

Users function the GRU by directly writing to the memory that is mmaped into
GRU space, ie; load/store directly to GRU space. The ioctls are used
infrequently by libgru.so to configure the driver during user initialization
and to handle errors that may occur.

For example, here is the code that is required to issue a GRU
instruction & wait for completion:


Function:

	/*
	 * Trivial example to load a cacheline of data from address <addr>.
	 * Data is loaded into byte 0 (hardcoded in the example) of the GRU data segment.
	 * Target address would likely be a function parameter but this is a stupid example.
	 *
	 * Function returns the status of the load. In this example, the load is synchronous.
	 * Real-life usage would probably split the vload() from the wait().
	 */
        int do_vload(void *cb, void *addr)
        {
                gru_vload(cb, addr, 0, XTYPE_CL, 1, 1, 0);
                return gru_wait(cb);
        }


00000000004005b0 <do_vload>:
  4005b0:       48 83 ec 18             sub    $0x18,%rsp
  4005b4:       48 89 77 10             mov    %rsi,0x10(%rdi)
  4005b8:       48 c7 47 18 01 00 00    movq   $0x1,0x18(%rdi)
  4005bf:       00
  4005c0:       c7 47 04 00 00 00 00    movl   $0x0,0x4(%rdi)
  4005c7:       48 c7 47 20 01 00 00    movq   $0x1,0x20(%rdi)
  4005ce:       00
  4005cf:       c7 07 01 06 02 00       movl   $0x20601,(%rdi)
  4005d5:       48 89 7c 24 10          mov    %rdi,0x10(%rsp)
  4005da:       0f ae 7c 24 10          clflush 0x10(%rsp)
  4005df:       31 c0                   xor    %eax,%eax
  4005e1:       f6 47 07 03             testb  $0x3,0x7(%rdi)
  4005e5:       74 05                   je     4005ec <do_vload+0x3c>
  4005e7:       e8 cc fe ff ff          callq  4004b8 <gru_wait_proc@plt>	# unlikely to be called - mainly ito handle errors
  4005ec:       48 83 c4 18             add    $0x18,%rsp
  4005f0:       c3                      retq

Unless an error occurs, there are no function calls involved. In many cases, the
entire code sequence would be inline.


--- jack
