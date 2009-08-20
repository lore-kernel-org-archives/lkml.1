Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbZHTU2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbZHTU2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZHTU2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:28:39 -0400
Received: from khc.piap.pl ([195.187.100.11]:35806 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbZHTU2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:28:39 -0400
To: David Miller <davem@davemloft.net>
Cc: walt@holmansrus.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
References: <985009134.71250769263099.JavaMail.root@mail.holmansrus.com>
	<m3skfmk39q.fsf@intrepid.localdomain>
	<20090820.122850.37712606.davem@davemloft.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 20 Aug 2009 22:28:38 +0200
In-Reply-To: <20090820.122850.37712606.davem@davemloft.net> (David Miller's message of "Thu\, 20 Aug 2009 12\:28\:50 -0700 \(PDT\)")
Message-ID: <m31vn6jkll.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> swiotlb emulates what hardware does, so if it can go wrong with
> swiotlb it can go wrong with hardware to.
>
> Figure out what the exact bug is.

I think I already have.

The exact bug is using streaming allocations for the descriptor.
It can't work consistently on all platforms, period. Streaming
allocation can only have one owner (either CPU or device) at a time, and
e100 driver wants access (for examining desc status) simultaneously with
the hardware (which may alter desc status at any time).

On ARM with the previous patch applied it can work because the CPU cache
has the "dirty" bits (e100 driver only reads from the descriptors).
On x86 without swiotlb it can work because streaming allocations are
already coherent.
On x86 with swiotlb it can't really work reliably (and if does, it does
by pure luck) because (I guess) swiotlb has no "dirty" flag and can't
know when it doesn't need to flush.

There is no other fix than to convert the desc rings to coherent
allocs. I'm going to do precisely that in few days, but we're stuck with
the existing code in 2.6.31 (and 2.6.30.x etc).
-- 
Krzysztof Halasa
