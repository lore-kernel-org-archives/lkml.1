Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbXLMVJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbXLMVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763985AbXLMVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:09:10 -0500
Received: from mx.neterion.com ([72.1.205.142]:1192 "EHLO owa.neterion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764282AbXLMVJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:09:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
Date: Thu, 13 Dec 2007 16:08:34 -0500
Message-ID: <78C9135A3D2ECE4B8162EBDCE82CAD7702B14004@nekter>
In-Reply-To: <OFD5B7D5E6.3538DC2A-ONC12573B0.0072D42A-C12573B0.00735730@de.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
Thread-Index: Acg9y1HXDpcQP339RlC+xsY7pB+iFgAAAqMA
References: <469958e00712131122s661dd970ud359389e1c6637d4@mail.gmail.com> <OFD5B7D5E6.3538DC2A-ONC12573B0.0072D42A-C12573B0.00735730@de.ibm.com>
From: "Caitlin Bestler" <Caitlin.Bestler@neterion.com>
To: "Joachim Fenkes" <FENKES@de.ibm.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>,
       "OF-General" <general@lists.openfabrics.org>,
       "LKML" <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
       "Or Gerlitz" <ogerlitz@voltaire.com>,
       "Roland Dreier" <rdreier@cisco.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joachim Fenkes [mailto:FENKES@de.ibm.com]
> Sent: Thursday, December 13, 2007 1:00 PM
> To: Caitlin Bestler
> Cc: Arnd Bergmann; caitlin.bestler@gmail.com; OF-General; LKML;
> linuxppc-dev@ozlabs.org; Or Gerlitz; Roland Dreier; Stefan Roscher
> Subject: Re: [ofa-general] Re: [ewg] Re: [PATCH] IB/ehca: Serialize
> HCA-related hCalls on POWER5
> 
> caitlin.bestler@gmail.com wrote on 13.12.2007 20:22:49:
> 
> > On Dec 13, 2007 12:30 AM, Or Gerlitz <ogerlitz@voltaire.com> wrote:
> > > The current implementation of the open iscsi initiator makes sure
> to
> > > issue commands in thread (sleepable) context, see iscsi_xmitworker
> and
> > > references to it in drivers/scsi/libiscsi.c , so this keeps ehca
> users
> > > safe for the time being.
> 
> > I agree, *some* form of FMR support is important for iSER (and
> probably
> > for NFS over RDMA as well). Rather than adding a crippled NO FMR
> > mode it would make more sense to add support for FMR Work Requests.
> > I'm not certain what, if any, impact that would have on the Power5
> problem,
> > but that's certainly a cleaner path for iWARP.
> 
> Well, FMR WRs wouldn't change the eHCA issue -- the driver would have
> to
> make an hCall in any case, and the architecture says that the hCalls
> used
> in this scenario might return H_LONG_BUSY, causing the driver to
sleep.
> No
> way around that. Because of this, eHCA's FMRs are actually standard
MRs
> with a different API.
> 
> If, as Or said, the iSCSI initiator issues commands in sleepable
> context
> anyway, nothing would be lost by using standard MRs as a fallback
> solution
> if FMRs aren't available, would it?
> 

To clarify, an FMR Work Request is simply posted to the SendQ like
any other Work Request (of course the QP has to be privileged, or
it will complete in error). An SQ Post should never block.

But yes, if the current iSCSI initiator always does all call-based
FMRs in a sleepable context then I would agree then any changes can
wait for the first vendor that wants to support FMR Work Requests.

FMR Work Requests can be pipelined, so anyone with hardware that
supported them would have strong motivation to enable the open
iSCSI initiator to take advantage of this.

