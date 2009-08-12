Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZHLMhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZHLMhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbZHLMhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:37:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZHLMhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH] kbuild: Do not select symbols with unmet dependencies
Date: Wed, 12 Aug 2009 14:36:58 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
References: <20090812112308.30683.24700.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090812112308.30683.24700.stgit@pc1117.cambridge.arm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908121436.58490.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19xDYVcPt0w6+EmBd7ZTylXtV0X+1ENL2otUrN
 iqe8VfwYEAX35pISOFOk+p7tjSn3DBXICLseewizvzbnM6scX2
 OXYAQPKiP/hWTA9biH5hA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 August 2009, Catalin Marinas wrote:
> The "select" statement in Kconfig files allows the enabling of options
> even if they have unmet direct dependencies (i.e. "depends on" expands
> to "no"). Currently, the "depends on" clauses are used in calculating
> the visibility but they do not affect the reverse dependencies in any
> way.
> 
> The patch introduces additional tracking of the "depends on" statements
> and does not allow selecting an option if its direct dependencies are
> not met, also printing a warning.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>

I guess this will change the behaviour of a number of subsystems,
likely causing unexpected regressions. I think your change
makes sense, but we need to be much more careful.

Can you extract a list of configuration symbols that are
impacted by your patch? A possibly way out could be to annotate
all of them first by changing

---
config FOO
	bool

config BAR
	depends on FOO

config BAZ
	select BAR
---

so that we either get

config BAZ
	select FOO
	select BAR

or alternatively, on a case-by-case basis

config BAZ
	depends on FOO
	select BAR

Once that is in place, all the symbols have a well-defined behaviour
and we can safely apply your patch.

	Arnd <><
