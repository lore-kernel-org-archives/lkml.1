Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZJDQrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZJDQrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 12:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbZJDQrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 12:47:03 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42833 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757440AbZJDQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 12:47:01 -0400
X-Sasl-enc: r2ETf11U5WXidxcWaySc1EXfnJHd/hLHLpU4+pb+kvee 1254674759
Date: Sun, 4 Oct 2009 13:45:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
Message-ID: <20091004164553.GD10505@khazad-dum.debian.net>
References: <1254669853.26496.0.camel@carter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254669853.26496.0.camel@carter>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Oct 2009, Miguel Ojeda wrote:
> Some broken batteries like my DELL NR2227 or a friend's DELL GK4798 return
> the design_capacity (charge_full_design) as capacity_now (charge_now)
> when completely charged.
> 
> I noticed this when looking at a battery plugin that reported "127% charged".
> Some of these plugins have already "fixed" this in userspace by coding
> something like min(percentage, 100)).

A battery can be charged above 100%.  It just depends what you call 100%,
and the "I am full" level *varies* in a non-monotonic way during the battery
lifetime...

So, if you don't want to see > 100%, you have to clamp it to 100% and lose
information (when your "100%" level is actually increasing as the thing
keeps charging and you keep raising the baseline so that it doesn't go over
100%).

> So I discovered that the battery wrongly returns charge_full_design when
> completely charged instead of charge_full.

Ick.

> This patch fixes this by returning min(capacity_now, full_charge_capacity)
> on both procfs and sysfs.

What will it cause on non-broken batteries?  Or during gauge reset, when any
battery that updates full_charge_capacity only at the end of the cycle will
really have capacity_now > full_charge_capacity ?

> Now the userspace plugins report the correct 100% and their userspace check
> may not be needed (if this error is the only one producing >100% results).

Like I said, > 100% can happen, unless what you define to be 100% is very
elastic (and gets updated all the time).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
