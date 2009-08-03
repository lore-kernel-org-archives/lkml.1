Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbZHCVrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbZHCVrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZHCVrC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:47:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:54164 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZHCVrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:47:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,316,1246863600"; 
   d="scan'208";a="480390707"
Subject: Re: iwlwifi (4965) regression since 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090728112102.GA3382@ics.muni.cz>
References: <20090726075738.GA21333@ics.muni.cz>
	 <1248710618.1216.452.camel@rc-desk>
	 <1248710775.9958.0.camel@johannes.local>
	 <20090728112102.GA3382@ics.muni.cz>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 14:47:01 -0700
Message-Id: <1249336021.30019.4304.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 04:21 -0700, Lukas Hejtmanek wrote:
> On Mon, Jul 27, 2009 at 06:06:15PM +0200, Johannes Berg wrote:
> > I'm not aware of any thinkpad-acpi rfkill problems, can you get the
> > rfkill tool and dump the status/list?
> > 
> > http://wireless.kernel.org/en/users/Documentation/rfkill
> 
> I figured it out.
> 
> I disable bluetooth usually just after system startup.
> 
> I disable bt using Fn+F5 which generates ACPI event: 
> ibm/hotkey HKEY 00000080 00001005
> 
> Which is OK.
> 
> But now (sinc 2.6.31-rcX), it silently toggles Soft block of WIFI. I have
> separate HW rfkill switch, it is only soft blocked. 

I tried this on a T61.

As you say, there are two "rfkill" related buttons on this platform, the
actual rfkill switch on the front and the Fn+F5 buttons. Trying these
out I saw the following (output annotated to be readable - index 0 is
bluetooth and index 1 is wifi). It looks to me like things are behaving
reasonably and I do not see that Fn+F5 changes wifi at all.

Some things I learned: 
- Fn+F5 does nothing if HW rfkill switch enabled
- if bluetooth SW disabled with Fn+F5 and you then toggle the HW rfkill
switch you will get bluetooth back.

# ./rfkill event
RFKILL event: idx 0 type 2 op 0 soft 0 hard 0
RFKILL event: idx 1 type 1 op 0 soft 0 hard 0
#now enable HW rfkill switch
RFKILL event: idx 1 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 2 op 2 soft 0 hard 1
RFKILL event: idx 0 type 2 op 2 soft 1 hard 1
RFKILL event: idx 1 type 1 op 2 soft 1 hard 1
#now disable HW rfkill switch
RFKILL event: idx 1 type 1 op 2 soft 1 hard 0
RFKILL event: idx 0 type 2 op 2 soft 1 hard 0
RFKILL event: idx 1 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 2 op 2 soft 0 hard 0
#now Fn+F5
RFKILL event: idx 0 type 2 op 2 soft 1 hard 0
#now Fn+F5
RFKILL event: idx 0 type 2 op 2 soft 0 hard 0
#now enable HW rfkill switch
RFKILL event: idx 1 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 2 op 2 soft 0 hard 1
RFKILL event: idx 0 type 2 op 2 soft 1 hard 1
RFKILL event: idx 1 type 1 op 2 soft 1 hard 1
#now Fn+F5
<nothing>
#now disable HW rfkill switch
RFKILL event: idx 1 type 1 op 2 soft 1 hard 0
RFKILL event: idx 0 type 2 op 2 soft 0 hard 0
RFKILL event: idx 1 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 2 op 2 soft 0 hard 0
#now Fn+F5
RFKILL event: idx 0 type 2 op 2 soft 1 hard 0
#now enable HW rfkill switch
RFKILL event: idx 1 type 1 op 2 soft 0 hard 1
RFKILL event: idx 0 type 2 op 2 soft 1 hard 1
RFKILL event: idx 0 type 2 op 2 soft 1 hard 1
RFKILL event: idx 1 type 1 op 2 soft 1 hard 1
#now Fn+F5
<nothing>
#now disable HW rfkill switch
RFKILL event: idx 1 type 1 op 2 soft 1 hard 0
RFKILL event: idx 0 type 2 op 2 soft 0 hard 0
RFKILL event: idx 1 type 1 op 2 soft 0 hard 0
RFKILL event: idx 0 type 2 op 2 soft 0 hard 0

Reinette



