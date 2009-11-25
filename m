Return-Path: <linux-kernel-owner+w=401wt.eu-S934375AbZKYJvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375AbZKYJvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbZKYJvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:51:37 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34068 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758276AbZKYJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:51:36 -0500
X-Sasl-enc: MH5NFQzeb6naE8BO2gEHzrbwgXc8b8ACeOM/5i8MPmxt 1259142701
Message-ID: <4B0CFE2A.6010008@ladisch.de>
Date: Wed, 25 Nov 2009 10:51:38 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Serge Belyshev <belyshev@depni.sinp.msu.ru>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
References: <4AF91F70.10106@ladisch.de>	<4B06501B.8080509@ladisch.de>	<87ws1l5wcl.fsf@depni.sinp.msu.ru>	<4B0673D7.5010006@ladisch.de>	<20091120123016.19d98ab4@hyperion.delvare>	<4B068402.7020606@ladisch.de>	<20091120131855.7f8f8722@hyperion.delvare>	<4B0A3DB6.9090703@ladisch.de>	<20091123145154.5b2b5735@hyperion.delvare>	<4B0AAA55.3040702@ladisch.de>	<20091123200527.1114cbc2@hyperion.delvare>	<4B0B9CB1.3090808@ladisch.de>	<20091124142654.76f4d166@hyperion.delvare>	<4B0BE935.1050708@ladisch.de> <20091124211134.12971937@hyperion.delvare>
In-Reply-To: <20091124211134.12971937@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Tue, 24 Nov 2009 15:09:57 +0100, Clemens Ladisch wrote:
> > This means that one of the already existing limit values must be the
> > reference base, so we'd need just a mechanism to specify which of them
> > is it, i.e., "temp1_relative_base: max".  If we'd have
> > "temp1_relative: 70000", the application would have to search among the
> > limit values for one with the same value.
> 
> I fail to see why the application would care about this at all. When in
> relative mode, all other values would be offset by the temp#_relative
> value. But that value itself would not be displayed (it has no physical
> value, otherwise we wouldn't be in absolute mode, would we?)
> ...
> 
> > temp1_relative: true
> 
> This is taking flexibility away from us, for no benefit that I can see.
> Am I missing something?

The application has to display something like "24 °C below the limit",
so how should it know that the 70°C should be named "the limit"?

To use an example, my CPU has these entries like these:
temp1_input: 29875
temp1_max: 70000
temp1_crit: 95000
temp1_crit_hyst: 92500

How should these entries be displayed?
(we know that: "40.1 °C below limit", "limit", "25 °C above limit" etc.)

But what algorithm should the application (or libsensors) use to create
those labels?  If we have "temp1_relative: 70000", then this happens to
be the "max" limit; but what if some CPU vendor decides to define, e.g.,
the value 0 as the "normal" operating temperatire, so that the entries
would look like this:
temp1_input: -1000
temp1_max: 40000
temp1_relative: 0
Should the values be labeled as "1 °C below normal" and "40 °C above
normal", and how should the application know that 0 is to be labeled
"normal"?  It might make more sense to display the temperature just as
"41 °C below max", in which case the actual value of temp1_relative is
not used at all.

"Relative" means that any value is meaningful only in comparison with
other values/limits, so it does not make sense to declare one point on
the scale as base.

> Additionally it wouldn't fit in libsensors as it exists today.

Then the best bet would probably be an entry like temp#_unit, with
0 = absolute °C (default); 1 = relative °C or °K; other values
"unknown".  Even if some silly scale is introduced later, applications
that read this entry then know that they must not display a unit like °C
for unknown unit specifications.


Best regards,
Clemens
