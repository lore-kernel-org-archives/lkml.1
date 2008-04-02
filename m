Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbYDBWMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbYDBWMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYDBWMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:12:37 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:50784
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYDBWMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:12:36 -0400
Date: Thu, 3 Apr 2008 00:12:28 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/9] Convert anon_vma lock to rw_sem and refcount
Message-ID: <20080402221228.GX19189@duo.random>
References: <20080401205531.986291575@sgi.com> <20080401205636.777127252@sgi.com> <20080402175058.GR19189@duo.random> <Pine.LNX.4.64.0804021107520.27337@schroedinger.engr.sgi.com> <20080402215604.GU19189@duo.random> <Pine.LNX.4.64.0804021455180.31247@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021455180.31247@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 02:56:25PM -0700, Christoph Lameter wrote:
> I am a bit surprised that brk performance is that important. There may be 

I think it's not brk but fork that is being slowed down, did you
oprofile? AIM forks a lot... The write side fast path generating the
overscheduling I guess is when the new vmas are created for the child
and queued in the parent anon-vma in O(1), so immediate, even
preempt-rt would be ok with it spinning and not scheduling, it's just
a list_add (much faster than schedule() indeed). Every time there's a
collision when multiple child forks simultaneously and they all try to
queue in the same anon-vma, things will slowdown.
