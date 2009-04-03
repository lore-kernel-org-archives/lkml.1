Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZDCA7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZDCA7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZDCA73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:59:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:2847 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZDCA72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:59:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gSHhJwROA7Cz/KuOaJzgDSaSKnbspbFq14ZWlDAQfrjFVDq2WojkS5+opzjH1U+51r
         bxIidEDIhIy9bXuotVlyAK84kUqqvoe1xb4ehQALYvQ7+XddBhc6bBsHEj38RSrwBoKe
         La+CScMoyd4rRRuxAM6GmsWWZLBoGBj2nDQk4=
MIME-Version: 1.0
In-Reply-To: <9b1675090904021754pdfe30f4ye7ab801277619d8d@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
	 <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
	 <alpine.DEB.2.01.0904021731060.6162@bogon.housecafe.de>
	 <9b1675090904021754pdfe30f4ye7ab801277619d8d@mail.gmail.com>
Date: Thu, 2 Apr 2009 18:59:27 -0600
Message-ID: <9b1675090904021759u5c9110fbpcc1e01f4db230370@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 6:54 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 6:38 PM, Christian Kujau <lists@nerdbynature.de> wrote:
>> On Thu, 2 Apr 2009, Trenton D. Adams wrote:
>>> I'm thinking of writing a script that monitors performance, and
>>> remounts as needed, lol.  WHAT A HACK. hehe.
>>
>> Ugh....my brain hurts :-\
>>
>> Christian.
>
> Yeah, mine too.
>

Just to make it hurt more for you, here you go...

On one console I run...
dd if=/dev/zero of=/tmp/bigfile bs=1M count=2000

On another I run...
perf-mon.sh
remounting with sync option, performance dropping
remounting without sync option, performance has stabilized

It may be better to write a C program that does a 1M fsync, and if
it's taking too long, then remount, lol.  Also, this script here,
using 1 min load average, will catch CPU intensity as well, which is
not really what I want.  Ah, it is a hack indeed. ROFL

#!/bin/sh

while true; do
    UPTIME=$(uptime | xargs | cut -d ' ' -f10 | sed 's/,//');
    if [ "$(echo "$UPTIME > 1" | bc)" -eq "1" ]; then
        mount | egrep 's-sys.*sync' >/dev/null
        if [ "$?" -ne "0" ]; then
            echo "remounting with sync option, performance dropping";
            mount -o remount,rw,sync /dev/s/sys /;
        fi
    else
        mount | egrep 's-sys.*sync' > /dev/null
        if [ "$?" -eq "0" ]; then
            echo "remounting without sync option, performance has stabilized";
            mount -o remount,rw /dev/s/sys /;
        fi
    fi;
    sleep 1
done
