Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbYDCBGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbYDCBGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbYDCBG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:06:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59020 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753535AbYDCBG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:06:26 -0400
Date: Wed, 2 Apr 2008 18:03:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: akpm@linux-foundation.org, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1 of 8] Core of mmu notifiers
In-Reply-To: <20080403004246.GA16633@duo.random>
Message-ID: <Pine.LNX.4.64.0804021758010.542@schroedinger.engr.sgi.com>
References: <a406c0cc686d0ca94a4d.1207171802@duo.random>
 <Pine.LNX.4.64.0804021527370.31603@schroedinger.engr.sgi.com>
 <20080403004246.GA16633@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thinking about this adventurous locking some more: I think you are 
misunderstanding what a seqlock is. It is *not* a spinlock.

The critical read section with the reading of a version before and after 
allows you access to a certain version of memory how it is or was some 
time ago (caching effect). It does not mean that the current state of 
memory is fixed and neither does it allow syncing when an item is added 
to the list.

So it could be that you are traversing a list that is missing one item 
because it is not visible to this processor yet.

You may just see a state from the past. I would think that you will need a 
real lock in order to get the desired effect.

