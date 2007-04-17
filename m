Return-Path: <linux-kernel-owner+w=401wt.eu-S1161204AbXDQReg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161204AbXDQReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161202AbXDQReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:34:36 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:10060 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161196AbXDQRef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:34:35 -0400
X-IronPort-AV: i="4.14,419,1170662400"; 
   d="scan'208"; a="478875283:sNHT47845216"
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [CRYPTO] is it really optimized ?
X-Message-Flag: Warning: May contain useful information
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	<E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	<38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	<adairbv57s2.fsf@cisco.com>
	<38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
	<ada7isb3qr2.fsf@cisco.com>
	<38b2ab8a0704171024m3d838bdak14370a7d0931557f@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Apr 2007 10:34:29 -0700
In-Reply-To: <38b2ab8a0704171024m3d838bdak14370a7d0931557f@mail.gmail.com> (Francis Moreau's message of "Tue, 17 Apr 2007 19:24:04 +0200")
Message-ID: <adalkgq3nx6.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2007 17:34:29.0344 (UTC) FILETIME=[A6F13E00:01C78116]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > It seems trivial to keep the last key you were given and do a quick
 > > memcmp in your setkey method to see if it's different from the last
 > > key you pushed to hardware, and set a flag if it is.  Then only do
 > > your set_key() if you have a new key to pass to hardware.
 > >
 > > I'm assuming the expense is in the aes_write() calls, and you could
 > > avoid them if you know you're not writing something new.

 > that's a wrong assumption. aes_write()/aes_read() are both used to
 > access to the controller and are slow (no cache involved).

Sorry, I wasn't clear.  I meant that the hardware access is what is
slow, and that anything you do on the CPU is relatively cheap compared
to that.

So my suggestion is just to keep a cache (in CPU memory) of what you
have already loaded into the HW, and before reloading the HW just
check the cache and don't do the actual HW access if you're not going
to change the HW contents.  So you avoid any extra aes_write and
aes_read calls in the cache hit case.

This would have the advantage of making anything that does lots of
bulk encryption fast without special casing ecryptfs.

 - R.
