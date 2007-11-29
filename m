Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbXK2ED6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbXK2ED6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 23:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbXK2EDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 23:03:50 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:24909 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbXK2EDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 23:03:49 -0500
Date: Thu, 29 Nov 2007 13:03:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Make KCONFIG_ALLCONFIG work with randconfig.
Message-ID: <20071129040329.GA10564@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Roman Zippel <zippel@linux-m68k.org>,
	Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071128122011.GB29552@linux-sh.org> <Pine.LNX.4.64.0711281751160.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711281751160.1817@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 06:08:16PM +0100, Roman Zippel wrote:
> On Wed, 28 Nov 2007, Paul Mundt wrote:
> > While allyes/mod/noconfigs do seem to work fine with KCONFIG_ALLCONFIG
> > provisions, randconfig tramples all over the provided values at perhaps
> > not surprisingly, random.
> 
> Please be careful with such broad statements, there is only an issue with 
> choice values.
> 
Ok, I'll rephrase, '100% of the provided values I tested with were being
randomly clobbered'. Is that better? Broken is broken, whether it applies
to a small subset of symbols or not.

> > Debugging this a bit, there seemed to be two issues:
> > 
> > 	- SYMBOL_DEF and SYMBOL_DEF_USER overlap, which made
> > 	  def_sym->flags the same regardless of whether we came from an
> > 	  KCONFIG_ALLCONFIG path or not.
> 
> Look at how SYMBOL_DEF is used in confdata.c.
> 
Ah, ok. I was just trying to find something I could test that would be
different for the KCONFIG_ALLCONFIG path, but it seems like is_new is a
much cleaner solution for this, thanks for pointing it out!

Updated patch follows.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 scripts/kconfig/conf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index a38787a..8d6f174 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -374,7 +374,8 @@ static int conf_choice(struct menu *menu)
 				continue;
 			break;
 		case set_random:
-			def = (random() % cnt) + 1;
+			if (is_new)
+				def = (random() % cnt) + 1;
 		case set_default:
 		case set_yes:
 		case set_mod:
