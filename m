Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYETXpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYETXpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 19:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbYETXoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 19:44:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450AbYETXol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 19:44:41 -0400
Date: Tue, 20 May 2008 16:28:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-Id: <20080520162816.e5dfeffa.akpm@linux-foundation.org>
In-Reply-To: <20080520231942.GX103491721@sgi.com>
References: <20080512002403.GP103491721@sgi.com>
	<Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com>
	<20080515231045.GY155679365@sgi.com>
	<Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
	<20080519054554.GY103491721@sgi.com>
	<Pine.LNX.4.64.0805190942530.18431@schroedinger.engr.sgi.com>
	<20080520002503.GC173056135@sgi.com>
	<20080520065622.GA13968@2ka.mipt.ru>
	<20080520214617.GU103491721@sgi.com>
	<20080520222505.GA23988@2ka.mipt.ru>
	<20080520231942.GX103491721@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 09:19:42 +1000 David Chinner <dgc@sgi.com> wrote:

> sync_inode() is far too
> heavy-weight to be used in a reclaim context

It's more than efficiency.  There are lots and lots of things we cannot
do in direct-reclaim context.

a) Can't lock pages (well we kinda sorta could, but generally code
   will just trylock)

b) Cannot rely on the inode or the address_space being present in
   memory after we have unlocked the page.

c) Cannot run iput().  Or at least, we couldn't five or six years
   ago.  afaik nobody has investigated whether the situation is now
   better or worse.

d) lots of deadlock scenarios - need to test __GFP_FS basically everywhere
   in which you share code with normal writeback paths.

Plus e), f), g) and h).  Direct-reclaim is a hostile environment. 
Things like b) are a real killer - nasty, subtle, rare,
memory-pressure-dependent crashes.

