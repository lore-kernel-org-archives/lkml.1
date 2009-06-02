Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZFBXjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZFBXjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZFBXjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:39:13 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:45343 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZFBXjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HbMrcc6xQ/SmH4eciigQx79bOQvjZNDqTHEJpgZQA4UP7NR2obXk5DipgUauE++K4R
         Rd/mXg4al4+SDkuPisEpxa/t6ksNySW6pkv3Rn9dRVdJL/Ay/6YNGkA4yjI66HeqsDK8
         c0o7/uxOhR5o+T449c3pToUCC37j6R1UVWN6E=
MIME-Version: 1.0
Date: Tue, 2 Jun 2009 19:39:12 -0400
Message-ID: <170fa0d20906021639w5daa0572p7c27e0d62cc03952@mail.gmail.com>
Subject: MD and DM (was: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft 
	RAID under Linux)
From: Mike Snitzer <snitzer@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>,
       linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ed Ciechanowski <ed.ciechanowski@intel.com>,
       Jacek Danecki <jacek.danecki@intel.com>,
       device-mapper development <dm-devel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 2, 2009 at 6:58 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Jun 2, 2009 at 1:11 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> Neil Brown wrote:
>>>
>>> I am pleased to (finally) announce the availability of
>>>   mdadm version 3.0
>>>
>>> It is available at the usual places:
>>>   countrycode=xx.
>>>   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
>>> and via git at
>>>   git://neil.brown.name/mdadm
>>>   http://neil.brown.name/git?p=mdadm
>>>
>>>
>>> This is a major new version and as such should be treated with some
>>> caution.  However it has seen substantial testing and is considerred
>>> to be ready for wide use.
>>>
>>>
>>> The significant change which justifies the new major version number is
>>> that mdadm can now handle metadata updates entirely in userspace.
>>> This allows mdadm to support metadata formats that the kernel knows
>>> nothing about.
>>>
>>> Currently two such metadata formats are supported:
>>>  - DDF  - The SNIA standard format
>>>  - Intel Matrix - The metadata used by recent Intel ICH controlers.
>>
>> This seems pretty awful from a support standpoint:  dmraid has been the sole
>> provider of support for vendor-proprietary up until this point.
>
> This bares similarities with the early difficulties of selecting
> between ide and libata.
>
>> Now Linux users -- and distro installers -- must choose between software
>> RAID stack "MD" and software RAID stack "DM".  That choice is made _not_
>> based on features, but on knowing the underlying RAID metadata format that
>> is required, and what features you need out of it.
>>
>> dmraid already supports
>>        - Intel RAID format, touched by Intel as recently as 2007
>>        - DDF, the SNIA standard format
>>
>> This obviously generates some relevant questions...
>>
>> 1) Why?  This obviously duplicates existing effort and code.  The only
>> compelling reason I see is RAID5 support, which DM lacks IIRC -- but the
>> huge issue of user support and duplicated code remains.
>
> The MD raid5 code has been upstream since forever and already has
> features like online capacity expansion.  There is also
> infrastructure, upstream, for online raid level migration.
>
>> 2) Adding container-like handling obviously moves MD in the direction of DM.
>>  Does that imply someone will be looking at integrating the two codebases,
>> or will this begin to implement features also found in DM's codebase?
>
> I made a proof-of-concept investigation of what it would take to
> activate all dmraid arrays (any metadata format, any raid level) with
> MD.  The result, dm2md [1], did not stimulate much in the way of
> conversation.
>
> A pluggable architecture for a write-intent log seems to be the only
> piece that does not have a current equivalent in MD.  However, the
> 'bitmap' infrastructure covers most needs.  I think unifying on a
> write-intent logging infrastructure is a good place to start working
> together.
>
>> 3) What is the status of distro integration efforts?  I wager the distro
>> installer guys will grumble at having to choose among duplicated RAID code
>> and formats.
>
> There has been some grumbling, but the benefits of using one
> linux-raid infrastructure for md-metadata and vendor metadata is
> appealing.  mdadm-3.0 also makes a serious effort to be more agreeable
> with udev and incremental discovery.  So hopefully this makes mdadm
> easier to handle in the installer.
>
>> 4) What is the plan for handling existing Intel RAID users (e.g. dmraid +
>> Intel RAID)?  Has Intel been contacted about dmraid issues?  What does Intel
>> think about this lovely user confusion shoved into their laps?
>
> The confusion was the other way round.  We were faced with how to
> achieve long term feature parity of our raid solution across OS's and
> the community presented us with two directions DM and MD.  The
> decision was made to support and maintain dmraid for existing
> deployments while basing future development on extending the MD stack,
> because it gave some feature advantages out of the gate.  So, there is
> support for both and new development will focus on MD.
>
>> 5) Have the dmraid maintainer and DM folks been queried, given that you are
>> duplicating their functionality via Intel and DDF RAID formats? What was
>> their response, what issues were raised and resolved?
>
> There have been interludes, but not much in the way of discussion.
> Hopefully, this will be a starting point.
>
> Thanks,
> Dan
>
> [1] http://marc.info/?l=linux-raid&m=123300614013042&w=2

dm-devel should be cc'd to get a dialog going with the DM team.
