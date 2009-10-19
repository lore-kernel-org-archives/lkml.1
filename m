Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZJSJlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZJSJlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZJSJlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:41:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZJSJlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:41:00 -0400
Date: Mon, 19 Oct 2009 11:41:01 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 1/3] scripts/get_maintainer.pl: Add patch/file search
	for keywords
Message-ID: <20091019094101.GB3414@pengutronix.de>
References: <cover.1255153863.git.joe@perches.com> <73a375fb516cc420fcff9a0489e29a5509fbf34e.1255153863.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <73a375fb516cc420fcff9a0489e29a5509fbf34e.1255153863.git.joe@perches.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joe,

On Fri, Oct 09, 2009 at 11:05:02PM -0700, Joe Perches wrote:
> Based on an idea from Wolfram Sang <w.sang@pengutronix.de>
>=20
> Add search for MAINTAINERS line "K:" regex pattern match in a patch or fi=
le
> Matches are added after file pattern matches
> Add --keywords command line switch (default 1, on)
> Change version to 0.21
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

I tested the patches and they work. Some comments below:

> ---
>  scripts/get_maintainer.pl |   37 +++++++++++++++++++++++++++++++++++--
>  1 files changed, 35 insertions(+), 2 deletions(-)
>=20
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index cdb44b6..102b766 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -13,7 +13,7 @@
>  use strict;
> =20
>  my $P =3D $0;
> -my $V =3D '0.20';
> +my $V =3D '0.21';
> =20
>  use Getopt::Long qw(:config no_auto_abbrev);
> =20
> @@ -37,6 +37,7 @@ my $scm =3D 0;
>  my $web =3D 0;
>  my $subsystem =3D 0;
>  my $status =3D 0;
> +my $keywords =3D 1;
>  my $from_filename =3D 0;
>  my $pattern_depth =3D 0;
>  my $version =3D 0;
> @@ -84,6 +85,7 @@ if (!GetOptions(
>  		'scm!' =3D> \$scm,
>  		'web!' =3D> \$web,
>  		'pattern-depth=3Di' =3D> \$pattern_depth,
> +		'k|keywords!' =3D> \$keywords,
>  		'f|file' =3D> \$from_filename,
>  		'v|version' =3D> \$version,
>  		'h|help' =3D> \$help,
> @@ -132,6 +134,8 @@ if (!top_of_kernel_tree($lk_path)) {
>  ## Read MAINTAINERS for type/value pairs
> =20
>  my @typevalue =3D ();
> +my %keyword_hash;
> +
>  open(MAINT, "<${lk_path}MAINTAINERS") || die "$P: Can't open MAINTAINERS=
\n";
>  while (<MAINT>) {
>      my $line =3D $_;
> @@ -149,6 +153,8 @@ while (<MAINT>) {
>  	    if ((-d $value)) {
>  		$value =3D~ s@([^/])$@$1/@;
>  	    }
> +	} elsif ($type eq "K") {
> +	    $keyword_hash{@typevalue} =3D $value;

It matches the way how the current implementation works, but I guess somewh=
en
this @typevalue-array should be converted into a hash like

	$types{$type} =3D $value;

or similar unless I missed something.

>  	}
>  	push(@typevalue, "$type:$value");
>      } elsif (!/^(\s)*$/) {
> @@ -188,6 +194,7 @@ if ($email_remove_duplicates) {
> =20
>  my @files =3D ();
>  my @range =3D ();
> +my @keyword_tvi =3D ();
> =20
>  foreach my $file (@ARGV) {
>      ##if $file is a directory and it lacks a trailing slash, add one
> @@ -198,11 +205,24 @@ foreach my $file (@ARGV) {
>      }
>      if ($from_filename) {
>  	push(@files, $file);
> +	if (-f $file && $keywords) {
> +	    open(FILE, "<$file") or die "$P: Can't open ${file}\n";
> +	    while (<FILE>) {

Maybe the file should be read completely to save the loop.

> +		my $patch_line =3D $_;
> +		foreach my $line (keys %keyword_hash) {

This variable should be named $key instead of $line IMHO.

> +		    if ($patch_line =3D~ m/^.*$keyword_hash{$line}/x) {
> +			push(@keyword_tvi, $line);
> +		    }
> +		}
> +	    }
> +	    close(FILE);
> +	}
>      } else {
>  	my $file_cnt =3D @files;
>  	my $lastfile;
>  	open(PATCH, "<$file") or die "$P: Can't open ${file}\n";
>  	while (<PATCH>) {
> +	    my $patch_line =3D $_;
>  	    if (m/^\+\+\+\s+(\S+)/) {
>  		my $filename =3D $1;
>  		$filename =3D~ s@^[^/]*/@@;
> @@ -213,6 +233,12 @@ foreach my $file (@ARGV) {
>  		if ($email_git_blame) {
>  		    push(@range, "$lastfile:$1:$2");
>  		}
> +	    } elsif ($keywords) {
> +		foreach my $line (keys %keyword_hash) {

ditto

> +		    if ($patch_line =3D~ m/^[+-].*$keyword_hash{$line}/x) {
> +			push(@keyword_tvi, $line);
> +		    }
> +		}
>  	    }
>  	}
>  	close(PATCH);
> @@ -286,6 +312,13 @@ foreach my $file (@files) {
>      }
>  }
> =20
> +if ($keywords) {
> +    @keyword_tvi =3D sort_and_uniq(@keyword_tvi);
> +    foreach my $line (@keyword_tvi) {
> +	add_categories($line);
> +    }
> +}
> +

A bit unrelated: I noticed that lkml gets always added due to "F: *". Maybe
this list should be skipped if there has been another mailing list found?

>  if ($email) {
>      foreach my $chief (@penguin_chief) {
>  	if ($chief =3D~ m/^(.*):(.*)/) {
> @@ -384,6 +417,7 @@ Output type options:
> =20
>  Other options:
>    --pattern-depth =3D> Number of pattern directory traversals (default: =
0 (all))
> +  --keywords =3D> scan patch for keywords (default: 1 (on))
>    --version =3D> show version
>    --help =3D> show this help information
> =20
> @@ -486,7 +520,6 @@ sub format_email {
>  }
> =20
>  sub find_starting_index {
> -
>      my ($index) =3D @_;
> =20
>      while ($index > 0) {
> --=20
> 1.6.5.rc3.dirty
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrcNC0ACgkQD27XaX1/VRsBXgCeKUVhb4UkYQxpcAiqJ5dJ57DA
6dUAnirYDU+f24E10rCjCZUSiC3DW/Be
=zoEe
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
