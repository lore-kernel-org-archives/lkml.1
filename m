Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbYFBLSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbYFBLSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759196AbYFBLR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:17:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60192 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbYFBLRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:17:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Date: Mon, 2 Jun 2008 13:18:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       mtk.manpages@gmail.com, kernel list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0805301451020.19914@blonde.site> <20080601161133.ea344adf.akpm@linux-foundation.org> <Pine.LNX.4.64.0806020906001.9534@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0806020906001.9534@blonde.site>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Cc9QItzU3NMqrvU"
Message-Id: <200806021318.26404.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Cc9QItzU3NMqrvU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, 2 of June 2008, Hugh Dickins wrote:
> On Sun, 1 Jun 2008, Andrew Morton wrote:
> > On Mon, 2 Jun 2008 01:00:40 +0200 Pavel Machek <pavel@suse.cz> wrote:
> > > > How about this:
> > > > 
> > > > - Add a new SYNC_FILE_RANGE_NON_BLOCKING
> > > > 
> > > > - If userspace set that flag, turn on writeback_control.nonblocking
> > > >   in __filemap_fdatawrite_range().
> > > > 
> > > > - test it a lot.
> > > 
> > > Works for me. Is the expectation that I code this? I can certainly
> > > provide testing ;-).
> > 
> > Something like this:
> 
> Though this fits very easily into the current kernel implementation,
> I don't think it's the right interface for userspace.
> 
> If we do go this kind of a way, then I'd say SYNC_FILE_RANGE_NON_BLOCKING
> needs to tell the caller how far it got before giving up, rather than just
> success or failure.  Why? um, um, because it feels right; and would help
> the caller help the kernel by not overloading it with needlessly repeated
> loop ranges - any stronger reasons?  But sync_file_range() was defined
> to return int rather than ssize_t, so that becomes awkward.
> 
> Never mind, I don't think it is the right way anyway.  We don't need
> additions to the existing sync_file_range() interface, we just need it
> to behave as naive people like Pavel and I expected it to behave in the
> first place: SYNC_FILE_RANGE_WRITE should be nonblocking (with respect
> to queue congestion, and maybe page locking also).

Well, frankly, I'm not sure if we need anything better than we already have.
In fact my numbers show that SYNC_FILE_RANGE_WRITE works quite well -
please see
http://sourceforge.net/mailarchive/message.php?msg_name=200806020122.36193.rjw%40sisk.pl
"early writeout" means that SYNC_FILE_RANGE_WRITE is used and the file with
the results is attached for convenience.

My interpretation of the results is here:
http://sourceforge.net/mailarchive/forum.php?thread_name=200806021238.17100.rjw%40sisk.pl&forum_name=suspend-devel

Thanks,
Rafael

--Boundary-00=_Cc9QItzU3NMqrvU
Content-Type: text/plain;
  charset="iso-8859-1";
  name="image_saving_data.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="image_saving_data.txt"

Labels:
W+ - early writeout enabled
W- - early writeout disabled
C+ - compression enabled
C- - compression disabled
E+ - encryption enabled
E- - encryption disabled
T+ - threads enabled
T- - threads disabled

The numbers are speed values in MB/s.


Box 1 (Single-core, Athlon 64 3000+ 1.8 GHz, 1 MB L2 cache, 1.5 GB RAM)

	W-C-E-T-	W+C-E-T-	W-C+E-T-	W+C+E-T-
Write:	26.2		27.4		46.5		78.6
Read:	27.5		27.5		83.5		83.8

	W-C-E+T-	W+C-E+T-	W-C+E+T-	W+C+E+T-
Write:	15.6		19.1		28.4		38.7
Read:	18.0		18.1		46.1		46.2

	W-C-E+T+	W+C-E+T+	W-C+E+T+	W+C+E+T+
Write:	N/A		N/A		27.9		37.5
Read:	N/A		N/A		46.4		46.4

For compressed images the compression ratio was approx. 0.30


Box 2 (Dual-core, Turion X2 TL-60 2 GHz, 2 x 512 KB L2 cache, 2 GB RAM)

	W-C-E-T-	W+C-E-T-	W-C+E-T-	W+C+E-T-
Write:	31.9		34.1		42.7		74.5
Read:	33.0		32.9		79.8		80.1

	W-C-E+T-	W+C-E+T-	W-C+E+T-	W+C+E+T-
Write:	16.7		22.0		23.9		34.0
Read:	22.2		22.2		47.6		47.9

	W-C-E+T+	W+C-E+T+	W-C+E+T+	W+C+E+T+
Write:	16.4		22.2		34.7		57.2
Read:	22.2		22.1		47.9		48.0

For compressed images the compression ratio was approx. 0.40


--Boundary-00=_Cc9QItzU3NMqrvU--
