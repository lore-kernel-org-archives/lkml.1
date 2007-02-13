Return-Path: <linux-kernel-owner+w=401wt.eu-S1751265AbXBMKv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbXBMKv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXBMKv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:51:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46750 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbXBMKv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:51:27 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [PATCH 1/6] AKT - Tunable structure and registration routines
Date: Tue, 13 Feb 2007 11:51:18 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
References: <20070130101143.296619000@bull.net> <p73y7n3fm7t.fsf@bingen.suse.de> <45D1908F.8080804@bull.net>
In-Reply-To: <45D1908F.8080804@bull.net>
Organization: -
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131151.19712.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 11:18, Nadia Derbey wrote:
> Andi Kleen wrote:
> > Nadia.Derbey@bull.net writes:
> > 
> >>+
> >>+This feature aims at making the kernel automatically change the tunables
> >>+values as it sees resources running out.
> > 
> > 
> > The only reason we have resource limit is to avoid DOS when one
> > resource consumes too much memory.  When there is no such danger then
> > there isn't any reason to have a limit at all and it could be just
> > eliminated (or set to unlimited by default)
> 
> Automatic tuning is a way to set the limit to unlimited, in a sense, 
> doesn't it? With this feature, we can leave the default limits as they 
> are for an "every-day" usage, and when a particular application runs on 
> the machine, authorize the limit to grow up as needed.

That would be effectively no limit, so why not just do away with them
completely? You have to solve the DOS issues first of course, either way.
  
> > Your feature doesn't address the DOS and without that there isn't
> > any reason to have limits at all. So what's the point? 
> 
> As I told Eric Biederman in another mail, DoS in ensured in AKT by 
> exporting the min and max values for each tunable to sysfs (actually 
> Eric complained about these min and max :-( ). These are RW atrributes 
> that make it possible for a sysadmin to set the max value a tunable can 
> ever reach, instead of letting it grow up to huge values.

Then you could just set the limit always to that max value and would
get the same effect.

Min limit doesn't make much sense to me because near all Linux data structures
are on demand only anyways (excluding mempools and a few special cases) 
and min is defined as the current number of used resources.

> Agree with you, BUT between the default max_files and the "too many 
> files" situation, there is a gap that can be crossed by automatically 
> tuning max_files, isn't there? e.g. max_file default value is NR_FILE 
> (0x2000), while Oracle expects to have it set to 0x10000.

The reason NR_FILE is by default relatively low is mostly because the existing
ulimits suck :-) .i.e. you want to limit the memory consumption 
of a user you limit the number of the user's processes and the number of files
per process -- then the max memory they can allocate in files is process ulimit*nr_files
[in theory in practice there are holes like in flight fds in unix socket fd passing]

But of course that ends up with either NR_FILE being far too low or process far
too low or too much memory anyways. In practice it doesn't work particularly
well.

The real solution for that is "beancounter" which has been posted in several
forms recently (from OpenVZ and from Google). Basically it adds real limits
(for much more than just file descriptors) per uid or container.

With such infrastructure in place NR_FILES could be set to unlimited, as long
as you have a reasonable (large) default per uid.
 
Similar reasoning applies to other resources which are currently limited.

I think you're just attacking the symptoms here instead of the  basic issue.
 
-Andi
