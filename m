Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYIYS5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYIYS5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYIYS5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:57:08 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:40032 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752982AbYIYS5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:57:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=dLDMxy1TDDyMIbPbooTDf5UQwqX1H7i5g/QMqp4k0jc/tSIoTHCWA2f3bNio8wzdymN8W4CBuJ4+B3mwcZw44IIs1eRnwyRuWE3QT3EMJeTk9tbPn1nwsJvJ93fRJMyR;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Date: Thu, 25 Sep 2008 11:56:08 -0700
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       Andrew Morton <akpm@linux-foundation.org>, jeffrey.t.kirsher@intel.com,
       david.vrabel@csr.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com,
       Ingo Molnar <mingo@elte.hu>, jesse.brandeburg@gmail.com
References: <20080923.150722.141587696.davem@davemloft.net> <200809250401.54818.elendil@planet.nl> <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0809251921340.18801@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809251156.10648.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2008 10:24 am Jiri Kosina wrote:
> On Thu, 25 Sep 2008, Frans Pop wrote:
> > Extra datapoint. As far as I've seen this problem has not yet been
> > reported by any people running Debian. This could point to X.Org as
> > Debian currently has 7.3 while I think the reports so far have been with
> > 7.4.
>
> Yes, I think that xorg/xorg i915 driver/libdrm/GEM/whatever are the
> biggest suspect currently, according to the data that has been gathered so
> far.

We have confirmation that this isn't GEM related; according to the Novell bug 
at https://bugzilla.novell.com/show_bug.cgi?id=425480 people have hit the 
problem with kernels w/o GEM.

That doesn't rule out i915 (though I don't think any changes have gone in 
since 2.6.26 that would have caused this) or xf86-video-intel.  It's possible 
that X is getting confused about BAR mappings somehow, resulting in a 
clobbered e1000e NVRAM, but why would the kernel version matter in that case?  
The only thing that comes to mind would be PAT...

Recent versions of the X drivers (using recent libpciaccess code) will try to 
map the resourceN_wc file in sysfs.  It's possible that the map size we end 
up using is wrong, leading to the situation Dave described earlier where we 
map too much MMIO space.

> Still, what confuses me a little bit -- the EEPROM of the card is set to
> all 0xff, once the corruption happens. Isn't that a quite a coincidence,
> that bytes representing "nothing" in this context are used?

Presumably one has to write all ones to the EEPROM BAR of the e1000 device to 
see that pattern?  Or is there some way of configuring the EEPROM such that 
it'll fail to respond to read cycles resulting in all ones for every read 
back (i.e. target abort)?

Jesse
