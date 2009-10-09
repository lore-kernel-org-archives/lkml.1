Return-Path: <linux-kernel-owner+w=401wt.eu-S933677AbZJIPr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbZJIPr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933646AbZJIPr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:47:59 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:34976 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622AbZJIPr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:47:56 -0400
MIME-Version: 1.0
In-Reply-To: <1255084379-12954-1-git-send-email-w.sang@pengutronix.de>
References: <1255084379-12954-1-git-send-email-w.sang@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 9 Oct 2009 09:46:58 -0600
X-Google-Sender-Auth: c135d23076e67cd7
Message-ID: <fa686aa40910090846u38cc3463j4f5d934aa412763f@mail.gmail.com>
Subject: Re: [RFC] scripts/get_maintainer: add emails based on keywords in the 
	patch
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Joe Perches <joe@perches.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 9, 2009 at 4:32 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Make get_maintainer.pl scan the modifying lines of a patch for a list of
> keywords and add an associated email if found. The first user is the
> devicetree-discuss mailing list which should always be cc'ed if a device tree
> property is inserted/removed (keyword 'of_get_property'). This patch is the
> result from commit 1965d30356c1c65660ba3330927671cfe81acdd5 entering mainline
> which seems to have been missed by all parties interested in the device tree
> (and at least had the documentation missing). As adding properties can happen
> anywhere and so there is no fitting fileglob, this keyword based approach is
> proposed.

Nice.  I cannot comment on the implementation, but I like the approach.

g.

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Joe Perches <joe@perches.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  scripts/get_maintainer.pl |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index cdb44b6..e1150ea 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -44,6 +44,11 @@ my $help = 0;
>
>  my $exit = 0;
>
> +my %keywords_to_mail = (
> +       'of_get_property' => 'L: devicetree-discuss@lists.ozlabs.org',
> +);
> +my $keywords_to_mail_match = join('|', keys %keywords_to_mail);
> +
>  my @penguin_chief = ();
>  push(@penguin_chief,"Linus Torvalds:torvalds\@linux-foundation.org");
>  #Andrew wants in on most everything - 2009/01/14
> @@ -188,6 +193,12 @@ if ($email_remove_duplicates) {
>
>  my @files = ();
>  my @range = ();
> +my @email_to = ();
> +my @list_to = ();
> +my @scm = ();
> +my @web = ();
> +my @subsystem = ();
> +my @status = ();
>
>  foreach my $file (@ARGV) {
>     ##if $file is a directory and it lacks a trailing slash, add one
> @@ -213,7 +224,11 @@ foreach my $file (@ARGV) {
>                if ($email_git_blame) {
>                    push(@range, "$lastfile:$1:$2");
>                }
> -           }
> +           # Check the lines which a patch modifies for keywords; add mail if found.
> +           } elsif (m/^[+-].*($keywords_to_mail_match)/o) {
> +               (my $keyword_mail = $keywords_to_mail{$1}) =~ s/^([LM]): //;
> +               push( @{ ($1 eq 'L') ? \@list_to : \@email_to }, $keyword_mail );
> +          }
>        }
>        close(PATCH);
>        if ($file_cnt == @files) {
> @@ -224,13 +239,6 @@ foreach my $file (@ARGV) {
>     }
>  }
>
> -my @email_to = ();
> -my @list_to = ();
> -my @scm = ();
> -my @web = ();
> -my @subsystem = ();
> -my @status = ();
> -
>  # Find responsible parties
>
>  foreach my $file (@files) {
> --
> 1.6.3.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
