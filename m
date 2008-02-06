Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbYBFCCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbYBFCCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761238AbYBFCCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:02:09 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:46182 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758789AbYBFCCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:02:06 -0500
X-YMail-OSG: wKfASaIVM1m4aVG8C8MDdwug._VsGRxcijBQTIzMjo_iiuDQ9fwXBlLaZQq5IRQYK93LTHyfHWA_2FzoIeAN4jM9efef2mBTKMDQ.Uhb.dilbViXJA--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matteo@rmnet.it, tomof@acm.org, mangoo@wpkg.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, scst-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <20080206102931C.fujita.tomonori@lab.ntt.co.jp>
References: <20080205223740L.tomof@acm.org> <C3CE56CB.57D4%matteo@rmnet.it>
	 <20080206102931C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 18:01:36 -0800
Message-Id: <1202263296.2220.130.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-06 at 10:29 +0900, FUJITA Tomonori wrote:
> On Tue, 05 Feb 2008 18:09:15 +0100
> Matteo Tescione <matteo@rmnet.it> wrote:
> 
> > On 5-02-2008 14:38, "FUJITA Tomonori" <tomof@acm.org> wrote:
> > 
> > > On Tue, 05 Feb 2008 08:14:01 +0100
> > > Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> > > 
> > >> James Bottomley schrieb:
> > >> 
> > >>> These are both features being independently worked on, are they not?
> > >>> Even if they weren't, the combination of the size of SCST in kernel plus
> > >>> the problem of having to find a migration path for the current STGT
> > >>> users still looks to me to involve the greater amount of work.
> > >> 
> > >> I don't want to be mean, but does anyone actually use STGT in
> > >> production? Seriously?
> > >> 
> > >> In the latest development version of STGT, it's only possible to stop
> > >> the tgtd target daemon using KILL / 9 signal - which also means all
> > >> iSCSI initiator connections are corrupted when tgtd target daemon is
> > >> started again (kernel upgrade, target daemon upgrade, server reboot etc.).
> > > 
> > > I don't know what "iSCSI initiator connections are corrupted"
> > > mean. But if you reboot a server, how can an iSCSI target
> > > implementation keep iSCSI tcp connections?
> > > 
> > > 
> > >> Imagine you have to reboot all your NFS clients when you reboot your NFS
> > >> server. Not only that - your data is probably corrupted, or at least the
> > >> filesystem deserves checking...
> > 

The TCP connection will drop, remember that the TCP connection state for
one side has completely vanished.  Depending on iSCSI/iSER
ErrorRecoveryLevel that is set, this will mean:

1) Session Recovery, ERL=0 - Restarting the entire nexus and all
connections across all of the possible subnets or comm-links.  All
outstanding un-StatSN acknowledged commands will be returned back to the
SCSI subsystem with RETRY status.  Once a single connection has been
reestablished to start the nexus, the CDBs will be resent.

2) Connection Recovery, ERL=2 - CDBs from the failed connection(s) will
be retried (nothing changes in the PDU) to fill the iSCSI CmdSN ordering
gap, or be explictly retried with TMR TASK_REASSIGN for ones already
acknowledged by the ExpCmdSN that are returned to the initiator in
response packets or by way of unsolicited NopINs.

> > Don't know if matters, but in my setup (iscsi on top of drbd+heartbeat)
> > rebooting the primary server doesn't affect my iscsi traffic, SCST correctly
> > manages stop/crash, by sending unit attention to clients on reconnect.
> > Drbd+heartbeat correctly manages those things too.
> > Still from an end-user POV, i was able to reboot/survive a crash only with
> > SCST, IETD still has reconnect problems and STGT are even worst.
> 
> Please tell us on stgt-devel mailing list if you see problems. We will
> try to fix them.
> 

FYI, the LIO code also supports rmmoding iscsi_target_mod while at full
10 Gb/sec speed.  I think it should be a requirement to be able to
control per initiator, per portal group, per LUN, per device, per HBA in
the design without restarting any other objects.

--nab

> Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

