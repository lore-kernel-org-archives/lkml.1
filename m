Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZD1XcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZD1XcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZD1XcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:32:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:40801 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbZD1XcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:32:08 -0400
Date: Tue, 28 Apr 2009 16:29:35 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Florian Mickler <florian@mickler.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <20090429011028.22c69b40@schatten>
Message-ID: <alpine.DEB.1.10.0904281622550.17268@asgard.lang.hm>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com> <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
 <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain> <alpine.DEB.1.10.0904281019580.17268@asgard.lang.hm> <alpine.LFD.2.00.0904281043420.22156@localhost.localdomain> <20090428234300.4a49d22f@schatten>
 <alpine.DEB.1.10.0904281447240.17268@asgard.lang.hm> <20090429011028.22c69b40@schatten>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Florian Mickler wrote:

> On Tue, 28 Apr 2009 14:50:08 -0700 (PDT)
> david@lang.hm wrote:
>
>> On Tue, 28 Apr 2009, Florian Mickler wrote:
>>
>>> perhaps there needs to be an infrastructure where each
>>> kconfig-entry-causer can also provide userlevel code to help with
>>> that entry?
>>>
>>> i could imagine a kconfig knob to specify an optional
>>> per-kconfig-userspace-helperscript which calculates a new "suggested
>>> value" at configure time.
>>> this "suggested value" is displayed next to the default value
>>> or is then already incorporated in the default value.
>>
>> what is the difference between the default value and this suggested
>> value?
>
> well... for example:
>
> ----snip----
> config MY_NEW_DRIVER
> bool "mynewDriver"
> default n
> helper obey
> help
>  this is my new shiny driver which speeds up the system by factor of
>  ten if the hardware is available. it the hardware is not available
>  this reduces performance by the factor of 5.
>  if unshure say 42.
> ----snap----
>
> and the helper line causes the Kconfig script to execute
> "some_path/userspacehelper.sh MY_NEW_DRIVER"
>
> with "obey", the return value would override the default value
>
> with "definitive_no", it would overide the default value with "no" if
> the script returned "no",
>
> with "definitive_yes", it would override the default value with "yes"
> if the script returned "yes"
>
> there could also be an msg displayed:
> "userspace config helper says: the machine seems to have the hardware
> but it has to be enabled in the bios!"
>
> maybe. maybe not.
>
> perhaps the "obey" "definitive_yes" "definitive_no" has to come from
> the helperscript too... dunno....
>
>
>>
>>> each maintainer of each kconfig entry
>>> a) decides if it is possible to supply such a script
>>> b) if it would be useful
>>> c) suplies and maintains his (focused on only one kconfig entry)
>>> script
>>
>> please no!!! we don't want to have to run 2000 different scripts to
>> get the settings.
>>
>> one script.
>>
>> David Lang
>
> hmm... alright, but that's not my main point here. the point is to
> have some infrastructure in the kconfig script for
> configure-time-hardware-detection.

_many_ people compile kernels on different hardware than they will be 
running it on.

keep the autodetect script seperate from the kernel compile/configure

in fact, if possible the autodetect script should not require the kernel 
source (to make it easier to do the autodetect on many different systems)

David Lang

> the rest is more an question of how to organize the work. however a
> modularized approach has more appeal in my eyes. but this was only
> me thinking out loud...
>
> there could be one script which facilitates the results of steve's
> allmod-cut-down script.
>
> i could also imagine having only one helperscript which knows it all.
> or there could be one which knows which script to call for what
> config-symbol.
>
> there could be the default-one, bundled with the kernel and
> third-party-scripts which may or may not fall back to the default one,
> but can override it.
>
> this would also enable some script to first generate some "hardware-id"
> and query the internet for known bad and known good config-facts for
> this platform and filter the in tree detection logic. (like when that
> machine has support for two equivalent services, but one is to be
> preferred on that platform because of a dumb biosbug or because of
> some social contract one has with the tasmanian devil)
>
> there are many options. it just needs to be done(tm)
>
> i'm gonna try to experiment a bit with smth like this, but maybe it
> turns out that the idea is not so good after all.  who knows...
>
>>
>>> c) if the script is 100% fool-proof he can say so in the
>>> description of the kconfig-entry or just skip the user or notify
>>> the user of the result.
>>> d) maybe dosn't provide an userspace helper
>>>
>>> this spreads the burden of the complex detection-code and hopefully
>>> eases configuration for everyone where possible.
>>>
>>> what do others think?
>>>
>>>
>>> sincerely,
>>> Florian
>>>
>
