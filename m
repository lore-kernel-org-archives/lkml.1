Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbXLWHyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbXLWHyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXLWHyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:54:36 -0500
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:23444 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751273AbXLWHyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:54:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=E+FF+PD05PALFZ+prkBrrzTH2oEoc0bBfD+9E/S3WHppcWIJb00YPRzjzZaEQ7GCLwrQ4DLyBd5lMFHBtltqna3hOIzlPc92AR50mp+bJqF8DcAtLVI3vrWTz3lVJTddZMT/aujuNwTlxTeYIRlIch9CwI7lmWwETgGFXYfPSg0=  ;
X-YMail-OSG: W6p4DOsVM1mVfTVxwmcJrXFNLXrAeYDVTshgkXgzVW_Rt758vzxQTBLrWXD1XMphLBMXJy6vIp7F4rajer97Tjh7EecXzzL_gw7PpY2KHU1IzMBFfg--
Date: Sun, 23 Dec 2007 08:52:40 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andy Whitcroft <apw@shadowen.org>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/checkpatch.pl: add a check for the patch level
	(patch -p<num>)
Message-ID: <20071223075240.GA5310@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, Andy Whitcroft <apw@shadowen.org>,
	rdunlap@xenotime.net, jschopp@austin.ibm.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071217071105.GA10869@gollum.tnic> <20071218054641.GA15994@gollum.tnic> <20071221181202.GU13186@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071221181202.GU13186@shadowen.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 06:12:02PM +0000, Andy Whitcroft wrote:
> On Tue, Dec 18, 2007 at 06:46:41AM +0100, Borislav Petkov wrote:
> > On Mon, Dec 17, 2007 at 08:11:05AM +0100, Borislav Petkov wrote:
> > 
> > A slightly microoptimized version 1.1:
> > 
> > ---
> > From: Borislav Petkov <bbpetkov@yahoo.de>
> > 
> > 
> > Check the patch level of the single hunks in a patch file, however only when
> > checkpatch.pl is called from within the kernel tree.
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > --
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 579f50f..3eda27b 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -653,6 +653,18 @@ sub CHK {
> >  	}
> >  }
> >  
> > +sub check_patchlevel {
> > +
> > +	if ($tree) {
> > +		my ($path) = @_;
> > +		$path =~ s![^/]*/!!;
> > +
> > +		if (!stat($path)) {
> > +			WARN("Check the patchlevel (hint: patch option -p)");
> > +		}
> > +	}
> 
> Hmmm that will trigger on all patches which create new files if I am
> grokking you correctly.
> 
> I would have thought this would pretty easy to check from the form of
> the names.  Hmmm.

Yep, I thought that too. Still, this way of checking the patch level using the
relative file pathname in the kernel tree seemed pretty straightforward so i
sent it. Off the top of my head, we could check for "/dev/null" on the "---"
line and skip that hunk... like so:

---
From: Borislav Petkov <bbpetkov@yahoo.de>

Check the patch level of the diff hunks in a patch text file. It works
only when checkpatch.pl is called from within the kernel tree. The only
case it misses is when the patch creates a new file and the patchlevel is wrong.
However, this cannot be checked for reliably using this approach of stat()ing
the relative url of the patched file.

 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..0fe80fb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -653,6 +653,22 @@ sub CHK {
 	}
 }
 
+sub check_patchlevel {
+
+	if ($tree) {
+		my ($path, $prev) = @_;
+
+# don't do any checking if it's a newly created file
+		return if $prev =~ m!/dev/null!;
+
+		$path =~ s![^/]*/!!;
+
+		if (!stat($path)) {
+			WARN("Check the patchlevel (hint: patch option -p)");
+		}
+	}
+}
+
 sub process {
 	my $filename = shift;
 	my @lines = @_;
@@ -713,10 +729,16 @@ sub process {
 #extract the filename as it passes
 		if ($line=~/^\+\+\+\s+(\S+)/) {
 			$realfile=$1;
+
+			if ($realfile) {
+				check_patchlevel($realfile, $lines[$linenr-2]);
+			}
+
 			$realfile =~ s@^[^/]*/@@;
 			$in_comment = 0;
 			next;
 		}
+
 #extract the line range in the file after the patch is applied
 		if ($line=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
 			$is_patch = 1;
-- 
Regards/Gruﬂ,
    Boris.
