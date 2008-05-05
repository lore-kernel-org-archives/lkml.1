Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYEETmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYEETmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYEETme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:42:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:46667 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYEETmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=i0bym2hgKXanAfUzI6VxSDUSaokbwnFnisW0NN7NGmj+4gfoWB7vtR8jhonJue6OeEAzipANTbrb8PvYx6451MkoC8Rv00Z+scz4D6/KKa0yiQXrObrOwfxFX5RaW2Q0r0yE7YR/E/lz5IfPjqHHOqVysxcQO5kOm/RCzMhNntI=
Message-ID: <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
Date: Mon, 5 May 2008 12:42:31 -0700
From: "Kevin Burton" <burton@tailrank.com>
To: "FD Cami" <francois.cami@free.fr>
Subject: Re: Ability to limit or disable page caching?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080505212831.22371732@olorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	 <20080505131607.5556b1f2@olorin>
	 <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	 <20080505212831.22371732@olorin>
X-Google-Sender-Auth: 024f886a6a6cc3a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah... I wanted to explain it in detail in a longer post.  If
necessary I'll do that as well.

I have a database process that's using 3G of memory. Then I have a
secondary process that's using about 500MB of memory.  This leaves
about 500MB free for anything else. The box has 4GB of memory total...
No swap is needed.

... swappiness is set to zero.

I've verified that overcommit or other issues aren't getting in the
way as I can run the box without swap.  This isn't possible when in
production though.

What's happening is that the kernel is deciding to swap out some
memory to disk in the (false) belief that it can free some up for
cache.

The problem is my database is already using its own cache so these are
conflicting philosophies here which make Linux perform in a
pathological way..

We're using O_DIRECT for our database which helps reduce the problem a
bit...... O_DIRECT bypasses the page cache and does all IO directly.
This means there isn't much pressure on the page cache and pages
aren't swapped out to disk.  However, MySQL still needs to do reads on
misc files which aren't O_DIRECT so I end up swapping but at a much
slower rate.

What I want to do is either disable the page cache entirely or just
tell the OS to cache at max 10% of the available memory.

Thoughts?

Kevin

On Mon, May 5, 2008 at 12:28 PM, FD Cami <francois.cami@free.fr> wrote:
> On Mon, 5 May 2008 11:34:24 -0700
> "Kevin Burton" <burtonator@gmail.com> wrote:
>
>> >> In the mean time is it possible to disable the page cache or limit it
>> >> to say 10% of system memory?
>> >
>> > You might want to look at /proc/sys/vm/ for tunables.
>> > /proc/sys/vm/vfs_cache_pressure and /proc/sys/vm/swappiness are probably
>> > what you are looking for.
>>
>> I haven't played with vfs_cache_pressure so I'll take a look at this.
>>
>> Unfortunately, swappiness doesn't work as intended.
>
> Could you explain the original problem ? That way we might help you better.
>
> Best,
>
> Francois
>



-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092
