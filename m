Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbYIYT6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbYIYT6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYIYT54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:57:56 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6708 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYIYT5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:57:55 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Tilman Baumann <tilman.baumann@collax.com>
Subject: Re: SMACK netfilter smacklabel socket match
Date: Thu, 25 Sep 2008 15:57:21 -0400
User-Agent: KMail/1.9.9
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org
References: <48DBC9A1.20900@collax.com> <200809251426.58179.paul.moore@hp.com> <89D091CB-9AE1-4792-AD3F-98754AF13C19@collax.com>
In-Reply-To: <89D091CB-9AE1-4792-AD3F-98754AF13C19@collax.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251557.21623.paul.moore@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 September 2008 3:26:40 pm Tilman Baumann wrote:
> Am 25.09.2008 um 20:26 schrieb Paul Moore:
> > On Thursday 25 September 2008 1:25:53 pm Tilman Baumann wrote:
> >> The intention behind this patch is that i needed a way to
> >> (firewall) match for packets originating from specific processes.
> >> The existing owner match did not work well enough, especially
> >> since the cmd-owner part is removed.
> >> Then i thought about a way to tag processes and somehow match this
> >> tag in the firewall.
> >> I recalled that SELinux can do this (SECMARK) but SELinux would
> >> have been way to complex for what i want. But the idea was born, i
> >> just needed something more simple.
> >
> > It appears the simplest option would be to provide the necessary
> > SECMARK
> > support in Smack.  SECMARK has provisions for supporting different
> > types of LSMs and adding Smack support should be relatively
> > trivial. In fact, it is possible for SECMARK to be made entirely
> > LSM agnostic and have it deal strictly with secctx/label and
> > secid/token values. We
> > would need to retain the SELinux specific interface for
> > legacy/compatibility reasons but I would encourage new patches to
> > take this more general approach rather than LSM specific extension.
>
> Sounds like a good idea. When i looked at the SECMARK code i could
> not get my
> head around the SELinux specific stuff, so i discarded the idea as to
> complex.
>
> For this to be complete i guess the CIPSO labels for SMACK would need
> to be taken into account.
> Far more than my quick and dirty approach, and probably more than i'm
> the right person to do it.
> Il try to understand the inner workings of the SECMARK stuff tough.

With SELinux the packet's CIPSO label (called the packet's peer label) 
is different from the SECMARK label.  Assuming you take a similar 
approach in Smack, you should be able to implement SECMARK without 
having to every concern yourself with the CIPSO label.

> >> This of course only works for packets with a local socket, but
> >> this was my intention anyway.
> >
> > You could also expand it to handle non-local senders.  However,
> > from my
> > discussions with Casey about Smack and network access controls,
> > enforcing policy against forwarded traffic is not something he is
> > interested in at this point.
>
> I have not investigated further into that, but if there is some way
> to match on CIPSO labels, there would be at least a vehicle to base
> this on.

Yes, in the absence of the sending socket to obtain the packet's peer 
label you need to examine the packet itself and any labeling 
information present on the packet; in the case of Smack this is CIPSO.

> > I don't like how the access control is being done outside of the
> > Smack LSM; once again I would encourage you to further investigate
> > the approach taken by SECMARK.  If you must do access control
> > outside of the LSM then please at least abstract the actual access
> > control decision, in this case strncmp(), to a LSM interface.
>
> Access control was actually not what i needed in this case.
> This would in this case as far as i know actually be done in the
> SMACK LSM.

Well, if you are accepting or dropping packets you are applying some 
form of access control.  I thought that was the point of your patch?  
If not perhaps I misunderstood or assumed too much.

> I'm not sure how much it would make sense to base firewall decisions
> on capability checks (i guess this is what you referring to).
> Like decisions in the form of who/what may access a process in which
> way.
> Please correct me if i understood you wrong.

Hmmm, the term "capability" is probably not the best term to use, but 
there are valid reasons to use the netfilter mechanism, i.e. SECMARK, 
to apply a network label to both incoming and outgoing packets.  The 
idea is that this allows the LSM to make network access control 
decisions based on the network attributes of a packet (address, 
protocol, port, etc.) and the powerful packet/connection matching 
mechanisms in netfilter.

> What i do with this match is just setting some CONNMARK and
> respectively FWMARKS to make crazy routing rules for different kinds
> (marked processes)
> of my outgoing traffic based on them.

I think I understand you goal now, essentially you want to route traffic 
based on the security label of the sender, yes?  There was some brief 
talk about this at the SELinux Developer's Summit this year at OLS.  
Unfortunately, it was just a casual conversation and I haven't seen any 
patches since then implementing security label based routing.

-- 
paul moore
linux @ hp
