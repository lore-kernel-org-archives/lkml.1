Return-Path: <linux-kernel-owner+w=401wt.eu-S1762924AbZFRNZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762924AbZFRNZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbZFRNZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:25:10 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48314 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbZFRNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:25:09 -0400
Date: Thu, 18 Jun 2009 15:25:10 +0200
From: Andreas Mohr <andi@lisas.de>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
       Ed Tomlinson <edt@aei.ca>, akpm@linux-foundation.org,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Message-ID: <20090618132510.GA1131@rhlx01.hs-esslingen.de>
References: <200906160747.04094.edt@aei.ca> <20090616205747.GA6356@rhlx01.hs-esslingen.de> <20090617001435.e2d86780.peter@piie.net> <20090617122022.GA13141@rhlx01.hs-esslingen.de> <cone.1245309039.632882.31537.1000@arca> <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com> <cone.1245322548.289821.31537.1000@arca> <9ea470500906180442r7beb49a8odcb3bf602df78b47@mail.gmail.com> <cone.1245325770.489357.31537.1000@arca> <9ea470500906180545j5e1a78f7qcb887ad843b489f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500906180545j5e1a78f7qcb887ad843b489f3@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 02:45:41PM +0200, Borislav Petkov wrote:
> ok, this starts to look quite a bit overengineered for no reason. First,
> acerhdf_revert_to_bios_mode() sets the fan to auto. Then, you've added
> a thermal_zone_device_update() call in there which does set the fan to
> auto indirectly _again_. And we end up with _three_ variables which
> represent only _one_ state. Here's what it should do:
> 
> suspend:
>  - set fan to auto
> 
> resume:
>  - the thermal layer figures out what to do based on the 'kernelmode' and
>  current temperature.
> 
> That's it, everything else is too much.

No, I'd say it's not as easy as that.
If you want to discover any weird state changes behind your back (and we
want that, that driver should be _safe_), then we need to record the current fan state
as set by us.

But that then means that during interruption of normal operation
(suspend), we need to temporarily stop this checking.

IOW, we need some more variable(s) to indicate:
OPERATION_SUSPENDED (set by .suspend)
OPERATION_ABOUT_TO_CONTINUE (set by .resume)
OPERATING

In state OPERATION_ABOUT_TO_CONTINUE the thermal layer function
would know that they shouldn't check fan state consistency, would
refresh fan state to the current state and then set it to OPERATING.

Or some such (would need further analysis).

Andreas Mohr
