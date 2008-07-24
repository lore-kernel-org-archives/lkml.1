Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYGXCnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYGXCnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 22:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYGXCm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 22:42:59 -0400
Received: from [209.191.84.64] ([209.191.84.64]:40121 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751095AbYGXCm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 22:42:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bCj1vyG2qskBSwWEkbJ1LRTsNt/jqWgPEBnZ4F21pBJVPxPOZrBJzDZvKyOkBdg+G2NfykL8cnE13BSI8oL//lZjI3beSOxgA/DqoRH9jO1ve+zL79hzD0rkz7KgoRa9BItzIrFbStxlYIxCPiT84/7UsNsyzO+R1Y/pMuWkjww=  ;
X-YMail-OSG: xI1me.IVM1lPnGNWvEo5zRBex4BNlrRiLqIul2M71tK8WvmZbZsiMxPgIKNIvp9AINdzIuT.aj0.8uHn4aIEqoy9F_VwNXemRdjhMeeIgiXeOdFtxWS9m0rSmHxoyKZOvN8-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: GRU driver feedback
Date: Thu, 24 Jul 2008 12:41:50 +1000
User-Agent: KMail/1.9.5
Cc: Jack Steiner <steiner@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080723141229.GB13247@wotan.suse.de>
In-Reply-To: <20080723141229.GB13247@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241241.50299.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 00:12, Nick Piggin wrote:

> Meanwhile, I hope that gives a bit to go on. I'm sorry it has come
> relatively late in the game, but I had a week off a while back then had
> (have) some important work work I'm starting to get a handle on...
>
> Thanks,
> Nick

Couple of other things I noticed today before I launch into the mmu
notifier and TLB invalidate code proper.

- gru_invalidate_range_end -- atomic_dec can filter into wake_up_all, past
  the spin_lock in __wake_up, and past the loading of the list of tasks. So
  you can lose a wakeup I believe (not on x86, but on ia64 with release
  ordering spinlocks it would be possible). atomic_dec_and_test should do
  the trick, and you might also want to consider memory ordering of the
  atomic_inc (haven't really looked, but it seems quite suspicious to allow
  it be reordered).

- you seem to be using cache flushes and memory barriers in different ways
  but each to push out things to the GRU device. For example start_instruction
  does a wmb() then a store, then a CPU cache flush.

  I'm lost as to how the mmio protocol actually works (not the low level
  protocol, but exactly what cache attributes are used, and how the CPU
  pushes things to the device and vice versa).

  For example, if you are using wmb(), this I think implies you are using
  UC or WC memory to map the device, in which case I don't see why you need
  the gru_flush_cache (which would suggest WB memory). Is this documented
  somewhere?

