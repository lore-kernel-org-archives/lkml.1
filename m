Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0BVWRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:17:00 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43659 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0BVWQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:16:58 -0500
Date: Mon, 22 Feb 2010 16:16:57 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 12/12] Kconfig and Makefiles to enable configuration
 and building of AppArmor.
Message-ID: <20100222221657.GB22194@us.ibm.com>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
 <1266572188-26529-13-git-send-email-john.johansen@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266572188-26529-13-git-send-email-john.johansen@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting john.johansen@canonical.com (john.johansen@canonical.com):
> From: John Johansen <john.johansen@canonical.com>
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> ---
>  security/Kconfig             |    6 ++++
>  security/Makefile            |    2 +
>  security/apparmor/.gitignore |    5 +++
>  security/apparmor/Kconfig    |   62 ++++++++++++++++++++++++++++++++++++++++++
>  security/apparmor/Makefile   |   25 +++++++++++++++++
>  5 files changed, 100 insertions(+), 0 deletions(-)
>  create mode 100644 security/apparmor/.gitignore
>  create mode 100644 security/apparmor/Kconfig
>  create mode 100644 security/apparmor/Makefile
> 
> diff --git a/security/Kconfig b/security/Kconfig
> index 226b955..bd72ae6 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -140,6 +140,7 @@ config LSM_MMAP_MIN_ADDR
>  source security/selinux/Kconfig
>  source security/smack/Kconfig
>  source security/tomoyo/Kconfig
> +source security/apparmor/Kconfig
> 
>  source security/integrity/ima/Kconfig
> 
> @@ -148,6 +149,7 @@ choice
>  	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
>  	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
>  	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
> +	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
>  	default DEFAULT_SECURITY_DAC
> 
>  	help
> @@ -163,6 +165,9 @@ choice
>  	config DEFAULT_SECURITY_TOMOYO
>  		bool "TOMOYO" if SECURITY_TOMOYO=y
> 
> +	config DEFAULT_SECURITY_APPARMOR
> +		bool "AppArmor" if SECURITY_APPARMOR=y
> +
>  	config DEFAULT_SECURITY_DAC
>  		bool "Unix Discretionary Access Controls"
> 
> @@ -173,6 +178,7 @@ config DEFAULT_SECURITY
>  	default "selinux" if DEFAULT_SECURITY_SELINUX
>  	default "smack" if DEFAULT_SECURITY_SMACK
>  	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
> +	default "apparmor" if DEFAULT_SECURITY_APPARMOR
>  	default "" if DEFAULT_SECURITY_DAC
> 
>  endmenu
> diff --git a/security/Makefile b/security/Makefile
> index da20a19..8bb0fe9 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_KEYS)			+= keys/
>  subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
>  subdir-$(CONFIG_SECURITY_SMACK)		+= smack
>  subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
> +subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
> 
>  # always enable default capabilities
>  obj-y					+= commoncap.o
> @@ -19,6 +20,7 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
>  obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
>  obj-$(CONFIG_AUDIT)			+= lsm_audit.o
>  obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
> +obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
>  obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
> 
>  # Object integrity file lists
> diff --git a/security/apparmor/.gitignore b/security/apparmor/.gitignore
> new file mode 100644
> index 0000000..0a0a99f
> --- /dev/null
> +++ b/security/apparmor/.gitignore
> @@ -0,0 +1,5 @@
> +#
> +# Generated include files
> +#
> +af_names.h
> +capability_names.h
> diff --git a/security/apparmor/Kconfig b/security/apparmor/Kconfig
> new file mode 100644
> index 0000000..01c8754
> --- /dev/null
> +++ b/security/apparmor/Kconfig
> @@ -0,0 +1,62 @@
> +config SECURITY_APPARMOR
> +	bool "AppArmor support"
> +	depends on SECURITY && SECURITY_NETWORK && NET && INET
> +	select AUDIT
> +	select SECURITY_PATH
> +	select SECURITYFS
> +	default n
> +	help
> +	  This enables the AppArmor security module.
> +	  Required userspace tools (if they are not included in your
> +	  distribution) and further information may be found at
> +	  <http://forge.novell.com/modules/xfmod/project/?apparmor>
> +
> +	  If you are unsure how to answer this question, answer N.
> +
> +config SECURITY_APPARMOR_NETWORK
> +       bool "AppArmor network support"
> +       depends on SECURITY_APPARMOR
> +       default n
> +       help
> +	 This enables AppArmor to mediate applications network use.
> +	 This will enable the SECURITY_NETWORK hooks.

Is there a compelling reason to have SECURITY_APPARMOR_NETWORK?   Does
it impact performance?  Is there older userspace that will just break?

-serge
