Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYF3Vle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYF3Vle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbYF3Vev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51669 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763191AbYF3Vee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:34 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 24/24] kconfig: make defconfig is no longer chatty
Date: Mon, 30 Jun 2008 23:35:18 +0200
Message-Id: <1214861718-32626-24-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make defconfig generated a lot of output
then noone actually read.
Use conf_set_all_new_symbols() to generate the default
configuration and avoid the chatty output.

A typical run now looks like this:
$ make  defconfig
*** Default configuration is based on 'i386_defconfig'
arch/x86/configs/i386_defconfig:13:warning: trying to assign nonexistent symbol SEMAPHORE_SLEEPERS
arch/x86/configs/i386_defconfig:176:warning: trying to assign nonexistent symbol PREEMPT_BKL
...
arch/x86/configs/i386_defconfig:1386:warning: trying to assign nonexistent symbol INSTRUMENTATION
$

As an added benefit we now clearly see the warnings generated
in the start of the process.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 scripts/kconfig/conf.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 6cdaa0c..9fba838 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -102,9 +102,6 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 		fflush(stdout);
 		fgets(line, 128, stdin);
 		return 1;
-	case set_default:
-		printf("%s\n", def);
-		return 1;
 	default:
 		break;
 	}
@@ -318,10 +315,6 @@ static int conf_choice(struct menu *menu)
 			else
 				continue;
 			break;
-		case set_default:
-			cnt = def;
-			printf("%d\n", cnt);
-			break;
 		default:
 			break;
 		}
@@ -589,13 +582,15 @@ int main(int ac, char **av)
 	case set_random:
 		conf_set_all_new_symbols(def_random);
 		break;
+	case set_default:
+		conf_set_all_new_symbols(def_default);
+		break;
 	case ask_silent:
 	case ask_new:
 		if (conf_silent_update())
 			exit(1);
 		break;
 	case ask_all:
-	case set_default:
 		if (conf_update())
 			exit(1);
 		break;
-- 
1.5.6.1.93.gef98

