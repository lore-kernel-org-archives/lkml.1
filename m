Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbZK3KgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbZK3KgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZK3KgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:36:07 -0500
Received: from ns.firmix.at ([62.141.48.66]:3166 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZK3KgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:36:04 -0500
Subject: Re: O_NOATIME and files in /proc
From: Bernd Petrovitsch <bernd@firmix.at>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, drepper@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20091120221108.1fb1dfcf@lxorguk.ukuu.org.uk>
References: <1258477590.16246.35.camel@tara.firmix.at>
	 <20091120133651.9df2da80.akpm@linux-foundation.org>
	 <20091120221108.1fb1dfcf@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 30 Nov 2009 11:36:00 +0100
Message-Id: <1259577360.28517.30.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.287 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.287 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Mon, 30 Nov 2009 11:36:09 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 22:11 +0000, Alan Cox wrote:
> On Fri, 20 Nov 2009 13:36:51 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 17 Nov 2009 18:06:29 +0100
> > Bernd Petrovitsch <bernd@firmix.at> wrote:
[...]
> > > Is there a specific reason that open can not open files (at
> > > least /proc/noatime and /proc/cpuinfo) under /proc with NO_ATIME as the
> > > following program shows:
> 
> Andreww: http://lkml.org/lkml/2004/6/14/184 seems to explain the origin
> of this. To follow it further you'd need to discuss it with Ulrich I
What is the best to reach him?
Via drepper@gmail.com?

> imagine and see why glibc expected that behaviour and in turn where it
> came from and what security or similar concerns were anticipated.
Security reasons were the only issues I found there (and no links to
further papers/articles/motivation/literature).

For the more technical side (of the security concerns):
- I agree that it may be important to forcibly keep the atime (for files
  of other users including root) - at least for backups[0].
  However, I stumbled over it because I needed a file which changes
  over time for some periodic (as in every second) application
  and /proc/uptime was the first crossing my mind[1].
  Said application used O_NOATIME on each open() as it doesn't hurt
  anyways (and saves a little I/O - God knows how the root on the
  customers systems mounts filesystems).
  So the better solution in this case would have been to e.g. simply
  ignore the O_NOATIME flag (but make the open succeed). Yes, that
  can be solved in userspace too with a minimal wrapper function.

- *if* root (or whoever mounted it) already set "noatime" on a
  filesystem, the atime won't be updated anyways. So I can't see any
  security concern if the open() also requests O_NOATIME as it is not
  any change in behaviour.
  And since /proc/mounts is readable by any user, the user knows it.

- for procfs (and thus /proc): That seems to not store atime at all but
  returns always the "current" time.
  So I fail to see what rejecting O_NOATIME on procfs (for files of
  other users including root) may achieve.
  Perhaps it makes sense to judge this on a per-file basis.

Alas, perhaps selinux, capabilities and similar may invalid the above
thoughts (but I don't know enough of these extensive security frameworks
to comment on that).

	Bernd

[0]: I don't value "it can be proofed that user read the file" that
     much. Just knowing that a user open a given file doesn't imply that
     he actually read and actually understood it. Perhaps the user just
     misclicked the file and exited the filereader 0.5s after opening
     it.
[1]: Yes, that can also be solved differently - just more cumbersome.
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


