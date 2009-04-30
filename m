Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbZD3N1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbZD3N1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761801AbZD3N1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:27:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761188AbZD3N1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:27:11 -0400
Date: Thu, 30 Apr 2009 15:26:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 0/3] removing unwanted module configs
Message-ID: <20090430132605.GA5289@elte.hu>
References: <20090430030821.523327994@goodmis.org> <20090430071830.GC16737@elte.hu> <alpine.DEB.2.00.0904300908110.20374@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904300908110.20374@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > As it has been brought up last Kernel Summit, we want to make it easier
> > > for those that report bugs to build their own kernels, and maybe even
> > > bisect with git.  Some of these people are not programmers and do not
> > > understand the complexity of the configuration options. But to compile
> > > a distribution configured kernel on their boxes can take hours.
> > > 
> > > This patch series comes to the rescue. I wrote the first instance of
> > > streamline config when I bought a new box in 2005 and got frustrated
> > > with finding all the necessary configurations to boot it. It is a
> > > small (yet powerful) perl script.
> > > 
> > > Here's what it does:
> > > 
> > >  * Reads the modules that are load by using lsmod.
> > >  * Reads all Makefiles to map modules to CONFIG_* options
> > >  * Reads the Kconfig files to find dependencies and selects
> > >  * Figures out what CONFIGS are needed to compile the loaded modules
> > >  * Reads the .config and prints out a version with all module configurations
> > >     that not needed, disabled.
> > > 
> > > The next two patches add options to make.
> > > 
> > >  localmodconfig - this will run streamline_config.pl on the .config file
> > > 	and replace it at the end.
> > > 
> > >  localyesconfig - this will do the same as localmodconfig but will also
> > > 	sed -i s/=m/=y/  to turn all modules to core. It will also run
> > > 	the 'make oldcondfig' to fix it up and let the user handle
> > > 	andything that was changed by converting a module to core.
> > > 
> > > Anyway, this is now in git and as a series of patches here. My git 
> > > tree is based off of the latest Linus git tree.
> > > 
> > > Have fun!
> > 
> > Very nice and useful!
> > 
> > I have given it a try - it works to a certain degree, but does not 
> > seem to work fully. If i boot a Fedora distro kernel with this 
> > module setup:
> > 
> > aldebaran:~/linux/linux> lsmod
> > Module                  Size  Used by
> > sunrpc                253904  1 
> > ipv6                  349568  50 
> > cpufreq_ondemand       73248  0 
> > acpi_cpufreq           75408  0 
> > freq_table             70400  2 cpufreq_ondemand,acpi_cpufreq
> > dm_multipath           82256  0 
> > i2c_i801               75932  0 
> > i2c_core               87192  1 i2c_i801
> > serio_raw              71556  0 
> > pcspkr                 68352  0 
> > pata_jmicron           69504  0 
> > iTCO_wdt               78208  0 
> > shpchp                 99160  0 
> > iTCO_vendor_support    68868  1 iTCO_wdt
> > igb                   144412  0 
> > dca                    71976  1 igb
> > pata_acpi              70528  0 
> > ata_generic            71428  0 
> > 
> > note the 'igb' driver that is essential to be picked up. 'make 
> > localyesconfig' complains:
> > 
> >   module igb did not have configs CONFIG_IGB
> 
> Did the original .config have it set. It will not enable any 
> modules that are not already set.

no, it wasnt enabled. 

> > But:
> > 
> >   # CONFIG_IGB is not set
> > 
> > It did pick up other essential drivers - such as ext3. Why did it 
> > miss IGB? Here are all the missed drivers:
> > 
> > aldebaran:~/linux/linux> make localyesconfig
> > module ata_generic did not have configs CONFIG_ATA_GENERIC
> > module iTCO_vendor_support did not have configs CONFIG_ITCO_WDT
> > module shpchp did not have configs CONFIG_HOTPLUG_PCI_SHPC
> > module acpi_cpufreq did not have configs CONFIG_IA64_ACPI_CPUFREQ CONFIG_X86_ACPI_CPUFREQ
> > module pata_jmicron did not have configs CONFIG_PATA_JMICRON
> > module i2c_i801 did not have configs CONFIG_I2C_I801
> > module serio_raw did not have configs CONFIG_SERIO_RAW
> > module iTCO_wdt did not have configs CONFIG_ITCO_WDT
> > module freq_table did not have configs CONFIG_CPU_FREQ_TABLE
> > module igb did not have configs CONFIG_IGB
> > module ipv6 did not have configs CONFIG_IPV6
> > module dca did not have configs CONFIG_DCA
> > module sunrpc did not have configs CONFIG_SUNRPC
> > module pata_acpi did not have configs CONFIG_PATA_ACPI
> > module dm_multipath did not have configs CONFIG_DM_MULTIPATH
> > module cpufreq_ondemand did not have configs 
> > CONFIG_CPU_FREQ_GOV_ONDEMAND
> > module i2c_core did not have configs CONFIG_I2C
> > module pcspkr did not have configs CONFIG_INPUT_PCSPKR
> 
> Hmm, I just added the "localyesconfig" and have not played with it 
> much. I need to change the integrity check of the script to test 
> for modules that are already compiled in (CONFIG_FOO=y). Right now 
> it expects the modules to be modules :-/
> 
> > Of those drivers, igb is the only truly boot-critical one - the 
> > box wont be very useful if it has no network support.
> > 
> > Another comment: 'make localyesconfig' does not seem to be 
> > self-invariant. I.e. it does not handle the case well when we 
> > already have booted a localyesconfig kernel and do 'make 
> > localyesconfig' again. It will find no modules and will merrily 
> > create an almost empty .config.
> 
> It should not touch CONFIG_FOO=y. It should only disable the modules that 
> are already set but not needed.
> 
> I will update the script to not warn about modules that are compiled in.
> 
> > This could be addressed the following way: i think the script 
> > should implicitly turn on CONFIG_IKCONFIG=y, and should also 
> > check for the presence of /proc/config.gz and use it as a 
> > starting point. This makes the whole concept nicely 
> > self-invariant.
> 
> I really want to stay away from enabling anything in the .config 
> scripts. I can probably do it for the trivial cases. But there are 
> cases where more than one config will enable a module, or it takes 
> several types of dependencies to enable it. The script can not 
> know which is the best set of dependencies to enable, and I would 
> not want to enable all of them.

CONFIG_IKCONFIG=y would be a one-off thing, only to make the whole 
concept self-hosting. If i boot a localyesconfig kernel, how does 
the script figure out what is built in? It cannot, unless i provide 
it the precise .config - but often that wont be provided. The script 
should clone the environment it is running in really.

	Ingo
