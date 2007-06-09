Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931AbXFIE5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbXFIE5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 00:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXFIE5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 00:57:05 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:44304
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXFIE5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 00:57:04 -0400
Date: Fri, 8 Jun 2007 21:56:06 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sean <seanlkml@sympatico.ca>
cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname
 matching
In-Reply-To: <20070608232531.d68de09f.seanlkml@sympatico.ca>
Message-ID: <Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
 <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de>
 <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
 <200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
 <20070608232531.d68de09f.seanlkml@sympatico.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Sean wrote:

> 
> On Sat, 9 Jun 2007 11:01:41 +0900
> Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp> wrote:
>
>
> From the discussion so far, it seems that the different "model" that AA
> is trying to implement, is to do in one step what SELinux does in two
> steps; that is trying to combine labelling and enforcement into a
> single step.  If this is so, then why can't it just feed its automatic
> labelling into SELinux enforcement code?
>
>> I tried to give each file it's own label, but I couldn't do it.
>> http://sourceforge.jp/projects/tomoyo/document/nsf2003-en.pdf
>
> That paper seems entirely focused on the automatic generation of policy,
> and doesn't seem to help the discussion along.   For instance, there may
> be a way to implement AA on top of SELinux _without_ giving each and
> every file its own label.
>
>> There are many elements that forms too strong barrier between pathname and labels,
>> such as bind-mounts, hard links, newly created files, renamed files, temporary files and so on.
>> So I gave up giving each file a label that can be used as an identifier,
>> and took an approach to forbid unneeded mount operations, unneeded link operations,
>> unneeded renaming operations to keep the pathname represent it's own identifier as much as possible.
>
> AA must have a function that decides the security rights for any given
> path in order to make its enforcement decisions.  It must surely be able
> to deal with all those things you listed above (bind-mounts,hard links etc).
> So why can't those decisions be turned into labels that are fed into SELinux
> enforcement code?

with AA hardlinks are effectivly different labels on the same file

one of the big problems with SELinux is what label to put on new files 
(including temp files), the AA approach avoids this (frequent) problem 
entirely. In exchange AA picks up the (infrequent) problems of bind-mounts 
and hard-link creation. People have tried to equate these prolems to show 
that AA has just as many problems as SELinux, but you can run systems for 
decades without creating hard-links or bind-mounts

also you seriously misunderstand the AA approach

AA does NOT try to create a security policy for every file on the system.

Instead AA policies are based on specific programs, and each policy states 
what files that program is allowed to access.

if you are useing AA to secure all exposed services on a box you don't 
have to try to write a policy to describe what gcc is allowed to access 
(unless through policy you give one of your exposed services permission to 
run gcc, and even then I'm not sure if gcc would inherit restrictions 
from it's parent or just use it's own)

the resulting policy is much easier to understand (and therefor check) 
becouse it is orders of magnatude smaller then any comprehensive SELinux 
policy.

the AA policy is also much easier to understand becouse you can look at it 
in pieces, understand that piece, and then forget it and move on to the 
next piece.

for example, if you write a policy for apache that limits it's access to 
it's log files, install directories, and document root. then you write a 
policy for your log analysis tool to access it's libraries, report 
directories (under the apache document root) and the apache log files 
(read only), these two policies are independant, you don't have to think 
about one while creating the other (which you would have to do if you had 
to put one label on apache binaries, another on normal web documents, a 
third on the reports, a fourth on the log files, and a fifth on the 
binaries for the log analysis tool. and this is ignoring any overlap in 
libraries!)

AA also lets a sysadmin dip their toe in the water and just write a policy 
for Apache, not for anything else, then write a policy for firefox, then 
write a policy for their mail client, then for bittorrent, etc. there is 
no need or push to try and secure everything all at once, and no need to 
re-label files (and change any policies that used the old labels) when 
you discover a new interaction.

David Lang
