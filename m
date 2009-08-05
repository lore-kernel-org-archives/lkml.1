Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZHEL1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZHEL1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZHEL1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:27:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZHEL1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:27:35 -0400
Message-ID: <4A796C94.5040301@suse.de>
Date: Wed, 05 Aug 2009 20:27:16 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A7951B0.10208@suse.de> <20090805110031.51424dbe@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805110031.51424dbe@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

Alan Cox wrote:
> On Wed, 05 Aug 2009 18:32:32 +0900
> Tejun Heo <teheo@suse.de> wrote:
> 
>> Hello, Alan.
>>
>> Alan Cox wrote:
>>> This looks like a random private devel hack sand
>> Why so?
>>
>>> I don't see why it's appropriate for mainstream, especially as these
>>> "new things" don't exist mainstream either.
>> The new things is CUSE and it's already in mainstream.
> 
> Then fix it to use the sound interfaces properly. We have a multiplexor
> for sound devices so they can be shared between OSS/ALSA/whatever. Use it.
> Ditto if you want CUSE to handle miscdevices use the miscdevice interface
> properly.

The only problem here is the now obsolete hackish way OSS module
auto-loading is handled.  CUSE is being a regular chardev citizen.
The OSS multiplexing mechanism itself isn't a problem and the posted
patch doesn't distort it in any way but by preclaiming all OSS device
numbers, OSS requires its own different rule for no good reason.  The
only actual difference here would be what module aliases are used.

Given the situation, I sure can add hacks to CUSE so that it doesn't
do regular chardev thing but does OSS specific stuff if OSS major is
detected.  To me, this would be much painful exercise in spreading the
hack.

The proper solution would be extending chardev such that OSS sound
core can use its own custom module aliases for backward compatibility.
But given that OSS is about the only user left for such facility and
modern distros don't depend on the feature or can easily work around
it from userland, that would be an overkill.

Another option is to rip the custom module requesting code altogether.
It just doesn't matter at all anymore.  modprobe is smart enough to
work around those issues with a couple lines of configuration changes.
We can add those alises to feature-removal-schedule.txt and then kill
it in a year or so.  If OSS is still alive and well, I would have
chosen this path.

However, in-kernel OSS is largely dead or at least is dying a slow
death.  Native OSS drivers are no longer in development and the only
left user is in-kernel emulation from ALSA, which I'm sure have its
places but is getting more and more inadequate for general desktop
usage due to lack of software multiplexing.

I don't see much reason to go through feature removal process for the
now obsolete OSS-specific module requesting feature.  Allowing distros
to make the switch as they see fit and letting the code wither away is
the least painful way.

So, in summary, the hack here is how OSS does custom module requesting
and the proper solution would be removing the mis-feature according to
our feature removal protocol or reimplementing it in a non-hackish
way, both of which are unnecessarily painful and overkill at this
point.

Thanks.

-- 
tejun
