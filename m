Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYCECjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYCECjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 21:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbYCECj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 21:39:27 -0500
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:22552 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751630AbYCECj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 21:39:26 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 21:39:25 EST
From: bruno randolf <bruno@thinktube.com>
Organization: thinktube
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] Linux central regulatory domain agent - next stage
Date: Wed, 5 Mar 2008 11:32:23 +0900
User-Agent: KMail/1.9.7
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, "Jouni Malinen" <j@w1.fi>,
       "Larry Finger" <Larry.Finger@lwfinger.net>,
       "Sam Leffler" <sam@errno.com>, "Dan Williams" <dcbw@redhat.com>,
       "Ivan Seskar" <Seskar@winlab.rutgers.edu>,
       "Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
       "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Tim Gardner" <tim.gardner@canonical.com>,
       "Jean Tourrilhes" <jt@hpl.hp.com>
References: <43e72e890802261555i37d8f470q9ac16df8140740fe@mail.gmail.com>
In-Reply-To: <43e72e890802261555i37d8f470q9ac16df8140740fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051132.24020.bruno@thinktube.com>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 08:55:50 Luis R. Rodriguez wrote:
> I'd like to request for review and advice for the central regulatory
> domain agent (CRDA) we have been working towards in the Linux 802.11
> subsystem. I'm including linux-kernel in hopes of a wider review.
> Particularly I'd like advice on the best path we can take for the
> userspace agent which *could* eventually be required upon userspace,
> meaning *most* distributions will package it if they want decent
> regulatory 802.11 support. But first let me begin with a brief
> overview of the concept of a CRDA, the case for it, and patches
> submitted and reviewed so far.
>
> * Central regulatory domain agents - a case for it
>
> Contrary to all other drivers in the different subsystems in the
> kernel, 802.11 drivers have local regulatory laws to take into
> consideration for operation. To this day, due mainly to certification
> requirements, vendors have taken it upon themselves to make their
> hardware adhere to all regulatory regions their devices will be sold
> in. These requirements are now implemented in software on the host
> driver or firmware of the device. The reason for this is to enable the
> design of one 802.11 chipset with capabilities to operate in different
> geographical regions to reduce the cost of manufacturing, bring down
> the price of the products sold, and allow users to make use of their
> 802.11 devices in different countries they may go to. Another shift in
> market trends we are seeing is that of vendors moving away from a
> FullMAC [1] design model to a SoftMAC [2] design model for most their
> 802.11 chipsets; development-wise this means the drivers receive raw
> 802.11 frames instead of Ethernet frames and hence the need for
> mac80211, which provides a driver API to such type of devices and
> implements a basic STA MLME [3] in-kernel. Some SoftMAC devices also
> require complete regulatory control within the host driver. Some of
> these drivers end up implementing their own regulatory domain control
> and data structures. Except for the vendor-specific components of the
> code, usually frequency, power values and sometimes regulatory domain
> values, all of this code can instead be centralized as part of he
> 802.11 subsystem and shared amongst all the 802.11 drivers. This code
> sharing would provide a centralized regulatory domain control for
> devices which require regulatory domain control on the host, and
> additionally provide *enhanced effort* on our part in the operating
> system for compliance to local regulatory laws for devices which may
> have *out-of-date rules* or *buggy* regulatory domain control code.
>
> The above just addresses the present. What lies ahead for wireless
> seems to be making wireless devices smarter, more interoperable, but
> always compliant to local regulatory laws. Software Defined Radios
> (SDRs) [4] are a breed of wireless devices which are under the horizon
> and depending on the definition of an SDR used, can be considered to
> already be used and sold in the 802.11 market. Regulatory laws on SDR
> are relatively new and are still under review and vary depending upon
> geographical region. For example, the "The Software Freedom Law Center
> (SFLC) has examined the Federal Communication Commission's (FCC)
> rules", which when into into effect on July 6, 2007, "governing
> Software Defined Radio (SDR) devices and concluded that the rules do
> not restrict the activities of independent developers and distributors
> of Free and Open Source Software (FOSS) designed for use with SDR
> devices." [5] It also found that the "FCC's SDR rules create an
> opportunity for wireless hardware manufacturers, the FOSS community,
> and the FCC to communicate openly and productively about the ability
> of public disclosure and open standards to strengthen the security and
> robustness of wireless devices." With this in mind I think it is
> important to try to help the vendors achieve compliance with local
> regulatory laws and still remain compliant by supporting FOSS. Its
> arguable if this is possible or not, but let us please not get into
> this now; what I believe is more important is that we pave the way for
> the best technology possible for regulatory rules for 802.11 and also
> SDRs. A strong CRDA goes hand-in-hand with advancing SDRs as the
> attributes can be expanded as the technology does -- more modulations
> supported, different bands added, and so forth. Additionally a
> Frequency Broker [6] (note: this link is old and needs some updating
> but has the general idea) can later be added to register frequencies,
> power level, modulations which each wireless device present on a host
> is using to help with interoperability.
>
> A CRDA together with a Frequency Broker can therefore eliminate
> redundant regulatory domain code on host drivers, provide a convenient
> mechanism to update regulatory rules, and enhance interoperability
> between different type of wireless devices.
>
> * Implementation of the CRDA
>
> I posted my first series on October of 2006 [7] however the first
> series stuffed everything into the kernel, the data structures were
> overly complex, and no solid integration with mac80211 (d80211 then)
> was provided [8]. The second series, posted on September of 2007 [9],
> still left everything in the kernel, was more simplified and had
> integration with mac80211 and cfg80211, additionally zd1211rw was
> ported to the new framework and tested. After some discussion one the
> lists and IRC it was determined we should just move the database of
> regulatory domains into userspace and have just one regulatory domain
> defined in kernel space at a time. Userspace can then pass to kernel
> space a regulatory domain via the new nl80211. 802.11 devices can then
> register with cfg80211 its hardware capabilities and only allowed
> "channels" will be enabled, all others will be disabled. We can keep
> two standard regulatory domains in kernel space, however: a world
> regulatory domain which is a common denominator of all regulatory law
> -- its basically FCC with relaxed power requirements and no 5 GHz
> communication -- and a debug regulatory domain which enables
> everything.
>
> The regulatory domain used on the 802.11 subsystem will reflect the
> user's latest selected preference if one is set (this will override
> all settings), an 802.11 card's EEPROM reading, or country defined by
> an 802.11d country information element broadcast by a local access
> point (depending upon configuration and preferences).
>
> * Request for advice:
>
> cfg80211 can take the "installed" regulatory domain and only enable
> power settings / frequency settings dependent upon current defined
> regulatory rules. But in order to install a regulatory domain into the
> kernel we need userspace to upload it via nl80211. This is easily
> accomplished once userspace has one defined via structures defined in
> nl80211 for a regulatory domain. Regulatory domain rules vary,
> however, and I expect users to contribute on expanding the rules to be
> as accurate as possible. As such it *is* expected that as time goes by
> userspace will have rules updated, attributes added (will go
> hand-in-hand with nl80211 updates), or completely new regulatory
> domains defined. We therefore need a way to keep a database of
> regulatory domains, and a way to parse this database to finally hand
> to the kernel the desired regulatory domain.
>
> My initial take on this was to use a berkely db or sqlite db for the
> database and keep this local on hosts, however this would enforce
> certain package requirements upon most installations and do not think
> that's the best approach. Another approach is to keep the real
> database only on some development machines and let people send updates
> to it as well as view the database online. An output of the database
> can then be dumped as a flat file to a host in some format. The
> regulatory daemon would then parse this flat file and upon changes to
> the file update its local database of regulatory domains. I'd like
> feedback on suggestions for the file format used which would keep
> distributions requirements at a minimal. If there is some extremely
> light weight and acceptable database and database API most of us
> wouldn't mind seeing on most installs please name them too (although I
> don't think this is really a good idea).
>
> My preference is to keep the real database on a development box which
> has some web interface which people can use to view. Ideally users can
> then send updates to the database to provide updates to rules. The
> database can then be dumped and an application used to generate some
> flat file. Distributions can then pick this flat file up and propagate
> it to users. A user's host would have the CRDA userspace daemon
> running, and once a new file is downloaded the regulatory daemon is
> informed about it. The reg daemon would then parse the flat file and
> update its internal database and new regulatory rules would become
> available to the kernel. What I am not sure on is the best format to
> use for the flat file.

if at all, i'd suggest a simple binary format for that file. it's not that we 
would have to do a lot of searching thru it, so i think something 
database-like is not necessary. also it has to be included in embedded 
systems so it should be quite small. a text-based approach would make it too 
easy for users to change and override regulatory settings. i know the basic 
idea is to put the liability to the user, but at the same time i think we 
should not make it too easy to alter the regulatory rules.

actually i think the best way to keep and update the regulatory table is as 
part of a source tree! instead of building a huge new infrastructure - a 
server with a db which users can upload regulatory changes to, a review 
process for these changes, a file export for downloading the latest db, a 
file format for keeping the db on the host and then parsing them into the 
application - why not just maintain the regulatory rules as part of the 
source tree and use the processes (version management, peer review) we 
already have in place there?

well, which source tree? i don't really know. iw maybe? or would'nt it make 
sense to make a library which can be used by iw, wpa_supplicant, hostapd and 
other applications alike to access the wireless settings, including 
regulatory domains?

bruno
