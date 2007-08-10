Return-Path: <linux-kernel-owner+w=401wt.eu-S938587AbXHJPKC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938587AbXHJPKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:10:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935354AbXHJPJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:09:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:34226 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935111AbXHJPJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:09:41 -0400
Date: Fri, 10 Aug 2007 17:10:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Renato Golin <rengolin@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: joydev.c and saitek cyborg evo force
In-Reply-To: <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com> 
 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz> 
 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com> 
 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz> 
 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com> 
 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com> 
 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com> 
 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz> 
 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com> 
 <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz>
 <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Renato Golin wrote:

> sorry for the delay, below the report descriptor and attached is the 
> full report when I've connected the joystick.

Hi Renato,

I guess I can now see the problem. The important parts of the dump are

[11165.496717]   INPUT(6)[INPUT]
[11165.496722]     Field(0)
[11165.496726]       Physical(GenericDesktop.Pointer)
[11165.496733]       Usage(1)
[11165.496738]         GenericDesktop.X
[11165.496744]       Logical Minimum(0)
[11165.496749]       Logical Maximum(4096)
[11165.496754]       Physical Minimum(0)
[11165.496758]       Physical Maximum(4096)
[11165.496763]       Report Size(16)
[11165.496767]       Report Count(1)
[11165.496772]       Report Offset(0)
[11165.496776]       Flags( Variable Absolute )
[11165.496785]     Field(1)
[11165.496788]       Physical(GenericDesktop.Pointer)
[11165.496795]       Usage(1)
[11165.496799]         GenericDesktop.Y
[11165.496806]       Logical Minimum(0)
[11165.496810]       Logical Maximum(4096)
[11165.496815]       Physical Minimum(0)
[11165.496819]       Physical Maximum(4096)
[11165.496824]       Report Size(16)
[11165.496828]       Report Count(1)
[11165.496832]       Report Offset(16)
[11165.496837]       Flags( Variable Absolute )

... but later on we have

[11165.499897]   OUTPUT(129)[OUTPUT]
[11165.499901]     Field(0)
[11165.499904]       Logical(00ff.0100)
[11165.499912]       Usage(1)
[11165.499916]         GenericDesktop.X
[11165.499923]       Logical Minimum(-127)
[11165.499927]       Logical Maximum(127)
[11165.499932]       Physical Minimum(-10000)
[11165.499936]       Physical Maximum(10000)
[11165.499941]       Report Size(8)
[11165.499945]       Report Count(1)
[11165.499949]       Report Offset(0)
[11165.499954]       Flags( Variable Absolute )
[11165.499962]     Field(1)
[11165.499965]       Logical(00ff.0100)
[11165.499972]       Usage(1)
[11165.499976]         GenericDesktop.Y
[11165.499983]       Logical Minimum(-127)
[11165.499987]       Logical Maximum(127)
[11165.499992]       Physical Minimum(-10000)
[11165.499996]       Physical Maximum(10000)
[11165.500001]       Report Size(8)
[11165.500005]       Report Count(1)
[11165.500010]       Report Offset(8)
[11165.500014]       Flags( Variable Absolute )
[11165.500022]   FEATURE(11)[FEATURE]

As we call input_set_abs_params() both for input and output fields, I can 
easily see how the range gets corrupted.

Renato, does force feedback work properly in Linux with this device? If 
so, that would mean that the device has logical maximum and minimum for X 
and Y axes different in input and output, and we would need to handle this 
properly (we currently don't).

Thanks,

-- 
Jiri Kosina
SUSE Labs
