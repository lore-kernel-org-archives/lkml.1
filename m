Return-Path: <linux-kernel-owner+w=401wt.eu-S1762496AbZJODwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762496AbZJODwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 23:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761604AbZJODwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 23:52:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51400 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757457AbZJODwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 23:52:06 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-58Mgvd+91+FidVEHk1o0"
Date: Thu, 15 Oct 2009 04:51:26 +0100
Message-Id: <1255578686.2488.228.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] scripts/get_maintainer.pl: add role output option
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-58Mgvd+91+FidVEHk1o0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add the output option '--roles' to get_maintainer.pl.  This causes it
to show the role of each email address, i.e. why it was selected.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/get_maintainer.pl |   52 ++++++++++++++++++++++++++++++++---------=
----
 1 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index cdb44b6..591fd3d 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -33,6 +33,7 @@ my $email_git_blame =3D 0;
 my $email_remove_duplicates =3D 1;
 my $output_multiline =3D 1;
 my $output_separator =3D ", ";
+my $output_roles =3D 0;
 my $scm =3D 0;
 my $web =3D 0;
 my $subsystem =3D 0;
@@ -78,6 +79,7 @@ if (!GetOptions(
 		'l!' =3D> \$email_list,
 		's!' =3D> \$email_subscriber_list,
 		'multiline!' =3D> \$output_multiline,
+		'roles!' =3D> \$output_roles,
 		'separator=3Ds' =3D> \$output_separator,
 		'subsystem!' =3D> \$subsystem,
 		'status!' =3D> \$status,
@@ -293,9 +295,9 @@ if ($email) {
=20
 	    $email_address =3D format_email($1, $2);
 	    if ($email_git_penguin_chiefs) {
-		push(@email_to, $email_address);
+		push(@email_to, [$email_address, 'chief penguin']);
 	    } else {
-		@email_to =3D grep(!/${email_address}/, @email_to);
+		@email_to =3D grep($_->[0] !~ /${email_address}/, @email_to);
 	    }
 	}
     }
@@ -309,7 +311,7 @@ if ($email || $email_list) {
     if ($email_list) {
 	@to =3D (@to, @list_to);
     }
-    output(uniq(@to));
+    output(merge_email(@to));
 }
=20
 if ($scm) {
@@ -381,6 +383,7 @@ Output type options:
   --separator [, ] =3D> separator for multiple entries on 1 line
     using --separator also sets --nomultiline if --separator is not [, ]
   --multiline =3D> print 1 entry per line
+  --roles =3D> show roles
=20
 Other options:
   --pattern-depth =3D> Number of pattern directory traversals (default: 0 =
(all))
@@ -537,11 +540,11 @@ sub add_categories {
 		}
 		if ($list_additional =3D~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
-			push(@list_to, $list_address);
+			push(@list_to, [$list_address, 'subscriber list']);
 		    }
 		} else {
 		    if ($email_list) {
-			push(@list_to, $list_address);
+			push(@list_to, [$list_address, 'open list']);
 		    }
 		}
 	    } elsif ($ptype eq "M") {
@@ -558,7 +561,7 @@ sub add_categories {
 		    }
 		}
 		if ($email_maintainer) {
-		    push_email_addresses($pvalue);
+		    push_email_addresses($pvalue, 'maintainer');
 		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
@@ -585,7 +588,7 @@ sub email_inuse {
 }
=20
 sub push_email_address {
-    my ($line) =3D @_;
+    my ($line, $role) =3D @_;
=20
     my ($name, $address) =3D parse_email($line);
=20
@@ -594,9 +597,9 @@ sub push_email_address {
     }
=20
     if (!$email_remove_duplicates) {
-	push(@email_to, format_email($name, $address));
+	push(@email_to, [format_email($name, $address), $role]);
     } elsif (!email_inuse($name, $address)) {
-	push(@email_to, format_email($name, $address));
+	push(@email_to, [format_email($name, $address), $role]);
 	$email_hash_name{$name}++;
 	$email_hash_address{$address}++;
     }
@@ -605,19 +608,19 @@ sub push_email_address {
 }
=20
 sub push_email_addresses {
-    my ($address) =3D @_;
+    my ($address, $role) =3D @_;
=20
     my @address_list =3D ();
=20
     if (rfc822_valid($address)) {
-	push_email_address($address);
+	push_email_address($address, $role);
     } elsif (@address_list =3D rfc822_validlist($address)) {
 	my $array_count =3D shift(@address_list);
 	while (my $entry =3D shift(@address_list)) {
-	    push_email_address($entry);
+	    push_email_address($entry, $role);
 	}
     } else {
-	if (!push_email_address($address)) {
+	if (!push_email_address($address, $role)) {
 	    warn("Invalid MAINTAINERS address: '" . $address . "'\n");
 	}
     }
@@ -714,7 +717,7 @@ sub recent_git_signoffs {
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
 		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line);
+	push_email_address($line, 'signed-off');
     }
 }
=20
@@ -795,7 +798,7 @@ sub git_assign_blame {
 	last if ($sign_offs < $email_git_min_signatures ||
 		 $count > $email_git_max_maintainers ||
 		 $sign_offs * 100 / $total_sign_offs < $email_git_min_percent);
-	push_email_address($line);
+	push_email_address($line, 'blamed');
     }
 }
=20
@@ -816,6 +819,25 @@ sub sort_and_uniq {
     return @parms;
 }
=20
+sub merge_email {
+    my @lines;
+    my %saw;
+
+    for (@_) {
+	my ($address, $role) =3D @$_;
+	if (!$saw{$address}) {
+	    if ($output_roles) {
+		push @lines, "$address ($role)";
+	    } else {
+		push @lines, $address;
+	    }
+	    $saw{$address} =3D 1;
+	}
+    }
+
+    return @lines;
+}
+
 sub output {
     my @parms =3D @_;
=20
--=20
1.6.4.3



--=-58Mgvd+91+FidVEHk1o0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAStacOOe/yOyVhhEJAQKf0w/7BVkozlKDnKrIIW+NpczUiAucEJfbboTg
jX/NuoPSUNij0XmackOi/XYvKJemOCHEfSqa88vDL2oSqOhG5Hg9BwCu4PIJ3nsR
Lq/epJezOk0p6NgJE38Pl7TyYNVwvD8kg67Ba20V4jMMYt41EbjK+ATVhhk+PWvT
vsL+t/qSiszATv3jTEL8xq5FGxlNCGKhV4j4HNhkRSvafXQmMoNzfBVD08F5omgD
ZfFdtIUouZhW/ifxupjNrt3Q3Pwkh8Obt/vmuAeNXXT/7bo5OlU2jkmcX2Yco6BP
5jLYdzwqU1DRtcOmKr/YcMZ6nQFLNLTZQOAuls+aavk6us08PFN2qUB6gOWrqhuM
1M8vEtAtS5X0h9cts7p3f81u5zF5e6/Hp2dpcl8A6Lt382NxzyqHK3lSaYNlIbDe
9Nli0AeDUVX1RL+61YQm37UK4+qxYUGUdDSUTsxGORjbdYKhD6Ra0BGQ94u/2PKO
3yaPyKlZ1rtAnOeW4f98blwUA61Os2kA2MCId3GbMHAhQUaf/utDCQjl+C7c4O77
wra5OieSNQiuubjbN5U9k+xPxIz43APxMCEcVc2rMud3906TFhomBzz9TmMR5bLg
NUxyiKXLsOqGE9Ehu3t8cRkdah5spdWc/AnVUHLy6Z+/2N7lh5QRJA4dE/0WwBqb
QtoxgZOHkEY=
=D8Co
-----END PGP SIGNATURE-----

--=-58Mgvd+91+FidVEHk1o0--
