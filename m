Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbZANWhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbZANWhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZANWg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:36:58 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:24636 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZANWg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:36:56 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Wed, 14 Jan 2009 17:36:43 -0500
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "SE-Linux" <selinux@tycho.nsa.gov>
References: <496D759A.7010401@gmail.com> <200901141508.58174.paul.moore@hp.com> <496E5A9D.3050105@gmail.com>
In-Reply-To: <496E5A9D.3050105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141736.43805.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 4:35:25 pm Justin P. Mattock wrote:
> Anyways heres what I'm trying to achieve:
>
> default looks like this:
> Configured NetLabel domain mappings(1)
> domain: DEFAULT
>     protocol: UNLABELED
>
> I want to try and have three of these for the
> different types of media:
> (in theory)
> Configured NetLabel domain mappings(3)
> domain:radio
>    protocol: UNLABELED
> domain:T.V.
>    protocol: UNLABELED
> domain:web
>    protocol: UNLABELED
> (and if possible three different tags(either 1,2,5), but probably can
> only do that with cipsov4);

Actually, in your case you are probably always going to want to send 
network traffic without any labels attached to the packets (no labeled 
IPsec or CIPSO) so you can stick with the default domain mapping 
configuration which sends all packets "unlabeled".  The part you should 
be concerned about is the static/fallback configuration which assigns 
network peer labels to packets which do not have labels attached to 
them by the remote host.

NOTE: the domain mapping configuration only controls how outbound 
network traffic is labeled on-the-wire; it "maps" the 
LSM/SELinux "domains" to a specific labeling protocol configuration, 
e.g. all apache_t traffic should be labeled with CIPSO DOI 3 while all 
firefox_t traffic should not be labeled at all.

> heres what I've come up with so far:
>
> netlabelctl -p map del default
>
> netlabelctl unlbl add domain:radio interface:wlan0 address:<myadd>
> label:system_u:object_r:netlabel_peer_t:s0
> netlabelctl unlbl add domain:radio interface:wlan0 address:<radioadd>
> label:system_u:object_r:netlabel_peer_t:s0
>
> netlabelctl unlbl add domain:T.V. interface:wlan0 address:<myadd>
> label:system_u:object_r:netlabel_peer_t:s0
> netlabelctl unlbl add domain:T.V. interface:wlan0 address:<t.v.add>
> label:system_u:object_r:netlabel_peer_t:s0

I think what you mean to type is the following:

 # netlabelctl unlbl add interface:wlan0 address:<radioadd> \
       label:system_u:object_r:netlabel_peer_t:s0

... note there is no "domain" argument, that only exists 
for "netlabelctl map ..." commands.

NOTE: if you really want to get fancy you can create new SELinux domains 
for each type of media and add NetLabel configurations for those new 
domains.  Imagine you create a new "internet_radio_t" domain/type and 
only allow the "netplayer_t" domain (yeah, I made that up but you get 
the point) access to network traffic labeled with internet_radio_t.  
You would then use the following command to label your incoming traffic 
with NetLabel:

 # netlabelctl unlbl add interface:wlan0 address:<radioadd> \
       label:system_u:object_r:internet_radio_t:s0

NOTE: you can also skip the "interface:wlan0" argument and just 
use "default" instead if you want the configuration to apply to all 
your network interfaces; although bear in mind that the "default" 
configuration can be overridden by the interface specific 
configurations.

> As for the new capabilities, I don't mind trying that out when
> the time comes(but first I need to figure the this out before any
> other ways);

No problem, I understand.  Let me know if you have any more problems.

> here is what the error looks like:
>
> netlabel_tools-0.19# make
> INFO: creating the version header file
> .: 10: version_info: not found
> make: *** [include/version.h] Error 2

Huh, can you try the following:

 1. Open the netlabel_tools-0.19/Makefile in your favorite editor
 2. Change the ". version_info; \" line to "source ./version_info; \"
 3. Save your changes
 4. Try running "make" again

Thanks.

-- 
paul moore
linux @ hp
