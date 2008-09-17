Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbYIQEkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbYIQEkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 00:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYIQEkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 00:40:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:57799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750856AbYIQEkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 00:40:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18HZahdypMHOZ9F0YAmwZ3nFKW1Lxo5qWQV8/Zayy
	u4YsBJFj6hsLer
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.mr.ZesyIB@albercik> <48CAE7A0.8000004@linux-foundation.org>
	 <1221306287.5213.111.camel@marge.simson.net>
	 <48CD1D25.9080301@linux-foundation.org>
	 <1221421907.4597.24.camel@marge.simson.net>
	 <1221475440.4784.39.camel@marge.simson.net>
	 <1221568105.5020.17.camel@marge.simson.net>
	 <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=utf-8
Date: Wed, 17 Sep 2008 06:39:51 +0200
Message-Id: <1221626391.5043.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 17:07 +0300, Ilpo Järvinen wrote:
> On Tue, 16 Sep 2008, Mike Galbraith wrote:
> 
> > On Mon, 2008-09-15 at 12:44 +0200, Mike Galbraith wrote:
> > > On Sun, 2008-09-14 at 21:51 +0200, Mike Galbraith wrote:
> > > 
> > > Since 2.6.22.19-cfs-v24.1 and 2.6.23.17-cfs-v24.1 schedulers are
> > > identical, and these are essentially identical with 2.6.24.7, what I
> > > read from numbers below is that cfs in 2.6.23 was somewhat less than
> > > wonderful for either netperf or tbench,  Something happened somewhere
> > > other than the scheduler at 23->24 which cost us some performance, and
> > > another something happened at 26->27.  I'll likely go looking again..
> > > and likely regret it again ;-)
> > 
> > Bisecting 26->27 yet again turned up a repeatable downturn in netperf
> > throughput.  There is no difference at this point with tbench. 
> > 
> > Bisect says first bad commit is 847106f, a security merge.  Post
> > bisection sanity checkouts say...
> > 
> > v2.6.26-21-g2069f45
> > 16384  87380  1        1       60.00    98435.13
> > 16384  87380  1        1       60.01    99259.90
> > 16384  87380  1        1       60.01    99325.61
> > 16384  87380  1        1       60.00    99039.84
> > 
> > v2.6.26-343-g847106f
> > 16384  87380  1        1       60.00    94764.59
> > 16384  87380  1        1       60.00    94909.89
> > 16384  87380  1        1       60.00    94858.63
> > 16384  87380  1        1       60.00    94801.12
> > 
> > ...every time.  I knew I'd regret doing this.
> 
> I assume that c142bda458a gave a good results as well...

Yes, just tried it.

> One additional sanity check could be to rebase security 6f0f0fd4963 on top 
> of the c142bda458a and then see if bisection among those security commits 
> on top yields to the the same result... Though I doubt it can change much 
> because there was not that much relevant non-security things in the merge 
> in question.

I'm not a master of git-foo, so that is not an option.  However, a dinky
bisection c142bda4..847106f very clearly says...

marge:..kernel/linux-2.6.27.git # git bisect bad
6f0f0fd496333777d53daff21a4e3b28c4d03a6d is first bad commit
commit 6f0f0fd496333777d53daff21a4e3b28c4d03a6d
Author: James Morris <jmorris@namei.org>
Date:   Thu Jul 10 17:02:07 2008 +0900

    security: remove register_security hook

    The register security hook is no longer required, as the capability
    module is always registered.  LSMs wishing to stack capability as
    a secondary module should do so explicitly.

    Signed-off-by: James Morris <jmorris@namei.org>
    Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
    Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 0177ef46d305e51e27bfcc4350a40577f8ba8d3d 64b64c10a424df4539653a8ee34f1a2329300931 M      include
:040000 040000 e318891e514de674fd064f6bfad70d5633b1aff1 0dbb38d5aa7fc3e4b2e09dc65796ce7cd5faeb26 M      security

git bisect start
# good: [c142bda458a9c81097238800e1bd8eeeea09913d] Merge branch 'drm-reorg' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect good c142bda458a9c81097238800e1bd8eeeea09913d
# bad: [847106ff628805e1a0aa91e7f53381f3fdfcd839] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6
git bisect bad 847106ff628805e1a0aa91e7f53381f3fdfcd839
# good: [cea78dc4ca044e9666e8f5d797ec50ab85253e49] SELinux: fix off by 1 reference of class_to_string in context_struct_compute_av
git bisect good cea78dc4ca044e9666e8f5d797ec50ab85253e49
# good: [65fc7668006b537f7ae8451990c0ed9ec882544e] security: fix return of void-valued expressions
git bisect good 65fc7668006b537f7ae8451990c0ed9ec882544e
# good: [b478a9f9889c81e88077d1495daadee64c0af541] security: remove unused sb_get_mnt_opts hook
git bisect good b478a9f9889c81e88077d1495daadee64c0af541
# good: [93cbace7a058bce7f99319ef6ceff4b78cf45051] security: remove dummy module fix
git bisect good 93cbace7a058bce7f99319ef6ceff4b78cf45051
# bad: [6f0f0fd496333777d53daff21a4e3b28c4d03a6d] security: remove register_security hook
git bisect bad 6f0f0fd496333777d53daff21a4e3b28c4d03a6d


