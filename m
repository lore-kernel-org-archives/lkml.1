Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZD3OXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZD3OXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbZD3OXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:23:09 -0400
Received: from web50107.mail.re2.yahoo.com ([206.190.38.35]:42845 "HELO
	web50107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754661AbZD3OXI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:23:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=XHHeIHfcIfRAD4KGyDa5fOCyJhLNyYOa/SVOgvV+jzaLtZDDAYU1jgKDJFaelGjsYePi3Zimg1PsPaBgnV3YCDhxeu2DbX3XYsm1NDnTquBVcPRvQtriiBCtr6jRgpr05P46oFmT0QOaeadrSWfEGgn0g3WXLfQgbJjWSD/3/nQ=;
Message-ID: <771929.40869.qm@web50107.mail.re2.yahoo.com>
X-YMail-OSG: wRuGW0cVM1kqWJE6l51m7v7Jwbz1oER7woiL8F3pbeUwnY94ZJF0h3cl2N_u3x0ep2ms6GLUPPW1uLDbwa925Aq5bxaP8JRgDtdzxO.QU00BEO0mB5q5T1dB00WVG59c0ATQqoK6G.YBhQOWLftJVZcESp.cFyTDXNoAy2XIzMY8WlPVQ.6eKSSTHPgb9Fj5VKCDUpCK9HZqEC.fAqpfPSrRc8UaqN3EeNZRU8vjq1xXwUkfRuBSDLz34cQ8oQgLsLeCLPoB3BA7TsXvGU_1R8pp5E6ZO3ytfmDdc31wlTnCEzr6jLDTGA5cJRSj12nZ
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Thu, 30 Apr 2009 07:23:05 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
To: Andi Kleen <andi@firstfloor.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



W1DUG


--- On Thu, 4/30/09, Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
> To: "Andi Kleen" <andi@firstfloor.org>
> Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Thursday, April 30, 2009, 5:57 AM
> Hi,
> 
> On Wed, Apr 29, 2009 at 09:30:31PM +0200, Andi Kleen
> wrote:
> > Borislav Petkov <borislav.petkov@amd.com>
> writes:
> > 
> > > Hi,
> > >
> > > thanks to all reviewers of the previous
> submission, here is the second
> > > version of this series.
> > 
> > The classic problem of the previous versions of these
> patches was that
> > they consume the same error registers (even if using
> pci config versus
> > msrs as access methods) as the kernel machine check
> poll/threshold
> > interrupt code.

Even the recommendation of AMD of having a polling thread for CORRECTABLE ERROR has a race issue to the same error registers due to the fact that a MCE is an exception and cannot be deferred or blocked off. In the middle of any poll cycle a MCE could fire and touch the same registers. small but present.

> >  And with two logging agents
> racing on the same
> > registers you will always get junk results. Typically
> with threshold 
> > enabled the mce code wins the race. I suspect this
> patchkit has
> > exactly the same fundamental design problem. EDAC
> really is not
> > particularly fitting for integrated memory controllers
> that report
> > their errors using standard machine check events.
> 
> ok, how about we remove tha MSR/PCI cfg space reading bits
> and leave
> that task solely to the mce core. Then, iff you have edac
> turned on in
> Kconfig, mce code delivers needed error info to edac which,
> in turn,
> goes and decodes the error/does the mapping to DIMM
> blocks/supplies DRAM
> error injection facility for testing purposes and similar
> things. That
> way you have both and they don't overlap in functionality.

Adding the synchronization between the two is very doable. It is not yet in the current patch set, but a work in progress.

That is the solution we are pursuing, to have a mechanism to provide communication between MCE and EDAC providing the mapping operation to a DIMM label. The MCA exception fires retrieves the info and calls EDAC module for address mapping.

MCE polling handler calls the EDAC module for address mapping.

EDAC's basic model is a polling operation on the error registers at a 1 second (tunable) rate. 

AMD's manual describes the UNCORRECTABLE MEMORY error handling via the MCE handler.  It further recommends a polling thread to harvest CORRECTABLE MEMORY errors. Last time I checked the MCE poller was running on a 5 minute poll cycle.

That is where we have 2 different threads polling the same error registers without synchronization is problematic and where a "Listener" pattern can be created to provide callbacks for both or form into a single poller operation.

> 
> By the way, I think there's a similar attempt/proposal of
> letting mce
> and edac talk to each other from Red Hat so I think this
> could be a
> viable thing to try.

Exactly

> 
> > -Andi (who thinks all of this decoding should be in
> user space anyways)
> 
> Think of a big data center with a thousands of 2,4,8 socket
> blades
> and the admin collecting mce output and running around
> decoding the
> errors on his workstation. Even worse, the blades have
> different DIMM
> configurations due to hw upgrades/newer machines. I'd much
> rather have
> the complete decoding done in kernel, where all the
> information needed
> for proper decoding is present and with the error landing
> in syslog or
> some other monitored buffer instead of reconstructing it in
> userspace.
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.

This model of clusters with thousands of multi-core nodes (5,000 in one case I think of) is used many times. The system console is tie to a serial port via a BIOS switch. The serial port is then attached to "conman" and all the consoles are funneled to a cluster controller which parses for a "bad memory" event.

In sites with EDAC deployed now the parser finds the node number, the CPU number on the node and extracts the EDAC DIMM label provided and generates a Repair Ticket. The technician proceeds to find the proper rack, blade and DIMM and takes that node out of service (for MCEs that are intermittent the node is reboot earlier). Then the bad DIMM is replaced - the one identified from EDAC - and the node quickly brought back online.

Without the DIMM Label provided by EDAC - or with just mce 'bad address' information - ALL the DIMMS are swapped out for off-line testing  or all are return for warranty replacement.  Getting the node back on line is the priority and reducing the time the technician spends on the rack floor. 

Bare MCE information is logged on the cluster controller and no time is spent trying to retrieve the log and running a user space program. Cheaper (man hours) and faster to swapout out all the DIMMs. But that is frowned on, with EDAC solving the problem for themnow.

The requested feature from the customers is to provide the DIMM label WITH the MCE error information as well.

doug t

