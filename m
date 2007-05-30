Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbXE3Xmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbXE3Xmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXE3Xmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:42:44 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15473 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXE3Xmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:42:43 -0400
X-IronPort-AV: i="4.14,595,1170662400"; 
   d="scan'208"; a="156646560:sNHT51918057"
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, axboe@kernel.dk,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
X-Message-Flag: Warning: May contain useful information
References: <20070530084752.GE14284@traven>
	<20070530123840.e54d73c2.zaitcev@redhat.com>
	<a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
	<20070530160850.0c536d55.zaitcev@redhat.com>
	<adasl9dq4zq.fsf@cisco.com>
	<20070530163236.8bd5640c.zaitcev@redhat.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 30 May 2007 16:42:41 -0700
In-Reply-To: <20070530163236.8bd5640c.zaitcev@redhat.com> (Pete Zaitcev's message of "Wed, 30 May 2007 16:32:36 -0700")
Message-ID: <adaodk1q3ny.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 May 2007 23:42:42.0078 (UTC) FILETIME=[37002BE0:01C7A314]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > > The negative is the sheer number of helper functions in list.h. Personally,
 > > > I find it difficult to retain a working knowledge of them. Iterators are
 > > > particularly nasty that way. I'm thinking about dropping all of these
 > > > list_for_each_with_murky_argument_requirements_and_odd_side_effects()
 > > > and use plain for(;;), as a courtesy to someone who has to read the
 > > > code years down the road.
 > > 
 > > I think I disagree with this reasoning.  If I'm reading your code and
 > > I see, say, list_for_each_entry_safe(), I can be pretty confident that
 > > your loop works correctly.  If you write your own for loop, then I
 > > have to check that you actually got the linked list walking right.
 > 
 > You have to check that I used list_for_each_entry_safe correctly too,
 > which is harder. Are you aware that we had (and probably still have)
 > dozens of cases where the use of list_for_each_entry_safe was buggy?
 > Most of them involved IHV programmers being lured into false sense
 > of security by the _safe suffix and getting their locking wrong.
 > 
 > You could not find a better way to blow up your own argument
 > than to mention list_for_each_entry_safe(), which is anything but.
 > Matthias' use of list_for_each_entry() actually IS safe, which is
 > why I am not NAKing it. Andrew has accepted it already. I just
 > think we aren't winning squat here.

Well, actually, I chose list_for_each_entry_safe() quite conscious of
the locking issues.  If I see list_XXX_safe() then I know that I need
to be suspicious when reviewing code -- the same way seeing "atomic_t"
makes me think "is there any reason to use atomic_t??"

If I just see

	for (pos = list_entry((head)->next, typeof(*pos), member),
		n = list_entry(pos->member.next, typeof(*pos), member);
	     &pos->member != (head);
	     pos = n, n = list_entry(n->member.next, typeof(*n), member))

then what am I to think?

 - R.
