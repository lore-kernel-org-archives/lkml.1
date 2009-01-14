Return-Path: <linux-kernel-owner+w=401wt.eu-S1764901AbZANRFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764901AbZANRFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764276AbZANRFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:05:33 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:19686 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764254AbZANRFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:05:30 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Wed, 14 Jan 2009 12:05:26 -0500
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "SE-Linux" <selinux@tycho.nsa.gov>
References: <496D759A.7010401@gmail.com> <200901140957.09722.paul.moore@hp.com> <496E0FB2.407@gmail.com>
In-Reply-To: <496E0FB2.407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141205.26904.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 11:15:46 am Justin P. Mattock wrote:
> Paul Moore wrote:
> > On Wednesday 14 January 2009 12:18:18 am Justin P. Mattock wrote:
> >> When using netlabelctl on a dell laptop
> >> I'm able to define the addresses that I want:
> >>
> >> netlabelctl unlbl add interface:wlan0 address:<radiostation>
> >> label:system_u:object_r:netlabel_peer_t:s0
> >> netlabelctl unlbl add interface:wlan0 address:<myaddress>
> >> label:system_u:object_r:netlabel_peer_t:s0
> >> netlabelctl  -p unlbl accept off
> >>
> >> {the above was from http://paulmoore.livejournal.com/1758.html };
> >

...

> >> (I'm able to listen to the radio station allowed, then if I choose
> >> another station; if I haven't defined an address like the above,
> >> mplayer just sits there.denying the unlabeled packet. that is
> >> until I allow the address);
> >> The problem I have is when I do the same on my macbook pro ati
> >> chipset. with the ath9k module, I'm able to listen to any station,
> >> search the web etc..
> >> it seems netlabelctl  -p unlbl accept off makes no difference if
> >> it's on or off.
> >>
> >> Is this built into ath9k yet, or is there something I'm missing?
> >
> > That is just plain odd, there isn't really anything that is driver
> > specific.  Can you share any more details like kernel version,
> > netlabel_tools verion, distro, etc?  I don't have any ath9k
> > hardware lying around to test so I would appreciate whatever
> > additional information you can provide.
>
> Hey alright.(I finally got around to  trying netlabelctl out!).

It's pretty cool.  In newer versions of netlabelctl I added an 
undocumented option to actually allow it to fix a sandwhich and do the 
dishes afterwards.  The exact command line option needed is left as an 
exercise for the reader :)

> The two systems I have for this are: Dell latitude x200
> running ubuntu jaunty, kernel is 2.6.29-rc1.
> with netlabel_tools_0.18 which was an rpm packaged
> that I converted to .deb.(can't remember the repository where I
> grabbed it from);
> The wireless card for the dell is a dell 1350
> using bcmxx(b43-phy0); works great.

Great.  I'm not a debian user so I can't be of much help on the 
packaging side, but you can get raw tarballs from the NetLabel project 
site on SF (the current release is 0.19 which includes support for all 
the goodies in 2.6.28):

 * http://netlabel.sf.net

> The results when using netlabelctl with the dell is nice, i.g. like I
> said as soon as I issue netlabelctl unlbl accept off, those addresses
> not defined are simply not allowed.(the problem with the dell is I'm
> not seeing any allow rules being generated: i.g.
>
> allow netlabel_peer_t netif_t:netif ingress;
> allow netlabel_peer_t node_t:node recvfrom;
> allow unlabeled_t netif_t:netif ingress;
> allow unlabeled_t node_t:node recvfrom;

[NOTE: the rules/permissions you list above are the "newer" network_peer 
permissions which are likely not active unless you are running a custom 
SELinux policy as the default Reference Policy hasn't made the switch 
yet to the newer system]

The netlabelctl tool doesn't generate any allow rules, all it does is 
configure the NetLabel subsystem which is all that is necessary 
because, this is important, NetLabel doesn't actually do any network 
traffic enforcement.  NetLabel is a network labeling framework, which 
means that it only deals with setting labels on outbound network 
packets and retrieving labels from inbound network packets 
(the "netlabel unlbl accept on|off" option is a gray area).  The 
decision about wether to accept or reject inbound network traffic is 
left to the LSM (NetLabel supports both SELinux and Smack).  If you 
want I can go into more detail but it would probably be rather boring 
and not really provide you much in the way of answering your question.

> The next is a macbookpro ati chipset the kernel is 2.6.29-rc1
> the o.s. is ubuntu jaunty, the netlabel_tools is the same as above.
> the only results I see out of this is the avc's it's generating
> (the allow rules above are from the macbook);
> some reason the dell doesn't generate any avc's,
> which makes me wonder is this a module issue.

Huh.  Just so I'm clear on this ... on the macbook you see avc denials 
that correspond to the allow rules you posted above, but on the dell 
you don't see the same avc denials?  Are you running the same SELinux 
policy on both systems (version numbers)?  What is the output of the 
following command on both systems?

 # cat /selinux/policy_capabilities/network_peer_controls

> Also I've gone through thinking, well maybe this is avc's driven,
> i.g. each address once added by netlabelctl receives a certain allow
> rule (like the allow rules above),
> if not either no allow rule is given to it,resulting in a denial you
> can't see in dmesg,
> or a denial that just won't be allowed by checkpolicy.
> So after seeing if this was the case I was left with  an address
> defined by netlabel(allowed) and defined the allow rules that it had
> created. unfortunately after all of that I still was able to turn on
> another radio station  that had  no  address  in netlabelctl's  unlbl
> database.(and no allow rule
> with SELinux);
> leading me to believe that the netlabel area or driver isn't working
> properly. or just told to not enforce the netlabel accept off option.

Well, like I said above, it shouldn't be a policy module or allow rule 
problem but I think you may be right in that the SELinux policy is a 
good place to start looking.  Compare the policy on the two systems to 
see if they are the same version and check to see if the new network 
peer controls are active (the cat command above; 0 is disabled, 1 is 
enabled).  Post what you find out.

> As for the list, I have linux-wireless in my address book(not sure
> which is right);

Not sure linux-wireless will have much to do about this but you included 
the SELinux which is good, thank you.

-- 
paul moore
linux @ hp
