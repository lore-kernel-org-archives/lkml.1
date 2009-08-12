Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZHLP5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZHLP5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZHLP5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:57:08 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:35127 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbZHLP5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:57:08 -0400
Date: Wed, 12 Aug 2009 17:57:06 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Nicolas Palix <npalix@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       yoann padioleau <yoann.padioleau@gmail.com>
Subject: Re: Typedef removal tool
In-Reply-To: <43e72e890908120845k435e5838sf40e90dfd6869b7d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0908121748160.8540@pc-004.diku.dk>
References: <43e72e890908111418m47910085k2d0016e2add8914f@mail.gmail.com> 
 <Pine.LNX.4.64.0908120659001.32131@ask.diku.dk>
 <43e72e890908120045s6e94bd5es480bb4ef1a66597c@mail.gmail.com> 
 <200908121423.06403.npalix@diku.dk> <43e72e890908120845k435e5838sf40e90dfd6869b7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW I was under the impression spatch wouldn't touch header files or
> dive in to untangle macros. Is that incorrect? Would the cocci files
> allow spatch to not only change typdef usages with simple struct uses
> but also redefine a typedef declaration to a simple struct definition
> through header files? For upstream work I don't expect as much macro
> mess as you would with typical vendor drivers. For drivers which do
> need to get ported I do expect an tangling web of macro mess one may
> need to put up with at times.

spatch looks at header files to a user-controllable degree: -no_includes 
means ignore all #includes, -local_includes means consider include 
files in the current directory, and -all_includes means consider all 
direct #includes.  There is no option to consider files that are included 
by included files.

If a header file is included, then spatch is willing to generate patches 
for transformations within the header file.  An inconvenience is that 
if a single header file is included multiple times, a patch will be 
generated for it each time as well.  In the worst case, these patches 
might not even be consistent.

There is also an increasing effort to take into account macro definitions, 
when they are available and useful.  I don't know the exact current status 
of that, however.  Perhaps Yoann (in CC) can explain.


In the general case, there it is not possible to write a rule to change a 
typedef to a simple structure declaration with the same name as the 
typedef.  The problem is that typedef declares something that is parsed as 
a type and the name of a struct is an identifier.  Spacth doesn't allow 
you to put a type in a position where an identifier is expected.  
Nicolas' code, however, gets around the problem by using python to 
generate new semantic patches.  In the new semantic patch, the typedef 
name is just a constant, and thus parsed as convenient for the position in 
which it appears (once as a type name and once as a struct name).


julia
