Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYH3KJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYH3KJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYH3KJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:09:28 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:54532 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYH3KJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:09:26 -0400
Message-ID: <48B91BF5.6040803@hypersurf.com>
Date: Sat, 30 Aug 2008 03:07:50 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] Add PERL script to conrol the PLL via the sysfs attribute
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a PERL script that can be used to manipulate the sysfs
attribute provided by pll_if. It can query the current state, change the
state of the inactive PLL, and switch PLLs (assumming that the inactive PLL is
locked to a valid frequency).

My name is Kevin Diggs and I approve this patch.

Signed-off-by: Kevin Diggs <kevdig@hypersurf.com>


Index: Documentation/cpu-freq/pll.pl
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ Documentation/cpu-freq/pll.pl	2008-08-29 13:34:36.000000000 -0700
@@ -0,0 +1,773 @@
+#!/usr/bin/perl -w
+
+=head1 NAME
+
+pll.pl - Provide user friendly interface to sysfs attribute for the 750GX PLL.
+This uses the pll_if module.
+
+=head1 	SYSNOPSIS
+
+ pll.pl [ -bdhtv ] [ -f { clk | ratio }]
+ b:	print bus frequency
+ d:	dump current pll configuration
+ h:	print simple usage information
+ f:	set frequency to specified clk (MHz) or ratio (r suffix)
+ t:	toggle selected pll. Use with -f to cause a switch to the newly
+ 	modified PLL on lock.
+ v:	enable verbose
+
+=head1 DESCRIPTION
+
+This utility provides a user friendly interface to the sysfs attribute that is
+provided by the pll_if module to control the PLL configuration register (HID1)
+in the IBM PowerPC 750FX and 750GX processors.
+
+=over 4
+
+=item -b
+
+print the bus frequency which is used along with the ratios to compute the
+processor clock frequency.
+
+=pod
+
+The method used to get the bus frequency is to use the value of the
+clock-frequency property from the root of the OF tree.
+
+=item -d
+
+prints the current value of the PLL configuration register in a human readable
+form (well ... more or less).
+
+=item -h
+
+print a simple help message.
+
+=item -t
+
+Toggles the selected PLL that is driving the cpu clock. When used with -f causes
+a switch to the new PLL upon lock (when the lock timeout expires).
+
+=item -v
+
+Enable verbose mode. Mostly just prints the file paths that stuff is pulled
+from.
+
+=item -f
+
+Sets the INACTIVE PLL to the selected clock frequency in MHz. If the value has
+an "r" suffix, it is taken as a ratio. This also recognizes the special value
+"off" (-foff) to turn off the INACTIVE PLL.
+
+=back
+
+=head1 AUTHOR
+
+kevin diggs
+
+=cut
+
+use warnings;
+use Getopt::Std;
+
+#
+#	The layout of the PLL register (HID1) is:
+#
+#	0  4|5 6|7|8| 9 11|12 13|14| 15 |16 20|21 22|23|24 28|29 30| 31
+#	PCE |PRE|v|v| Res | Res |v | PS | PC0 | PR0 |v | PC1 | PR1 |Res
+#                | |             |                   |
+#	 PSTAT1 -| |             |                   |
+#        ECLK -----|             |                   |
+#        PI0 --------------------|                   |
+#	 Res ----------------------------------------|
+#
+#	PCE	PLL0 read-only external config
+#	PRE	PLL0 read-only external range
+#	PSTAT1	PLL status (0 -> PLL0, 1 -> PLL1)
+#	ECLK	1 -> enable clkout pin
+#	PI0	PLL0 control:  0 -> external
+#	PS	PLL select:  0 -> PLL0, 1 -> PLL1
+#	PC0	PLL0 configuration
+#	PR0	PLL0 range
+#	PC1	PLL1 configuration
+#	PR1	PLL1 range
+#
+#	PLL_CFG		bus ratio	PLL_CFG		bus ratio
+#	 00000		   off		 10000		    8
+#	 00001		   off		 10001		   8.5
+#	 00010		 bypass		 10010		    9
+#	 00011		 bypass		 10011		   9.5
+#	 00100		    2		 10100		   10
+#	 00101		   2.5		 10101		   11
+#	 00110		    3		 10110		   12
+#	 00111		   3.5		 10111		   13
+#	 01000		    4		 11000		   14
+#	 01001		   4.5		 11001		   15
+#	 01010		    5		 11010		   16
+#	 01011		   5.5		 11011		   17
+#	 01100		    6		 11100		   18
+#	 01101		   6.5		 11101		   19
+#	 01110		    7		 11110		   20
+#	 01111		   7.5		 11111		   off
+#
+#	PLL_RNG		  range
+#	  00		600 -  900
+#	  01		900 - 1000
+#	  10		500 -  600
+#
+# IBM bit numbering:
+#  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
+# 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6
+#
+# 26 27 28 29 30 31
+#  5  4  3  2  1  0
+#
+*pllcBusFreqFile=\"/proc/device-tree/clock-frequency";
+#*pllcCPUPVR=\"/proc/device-tree/PowerPC,*/cpu-version";
+*pllcSysFS=\"/sys/devices/system/cpu/cpu0/*pll";
+
+#
+# Update the value of the PLL configuration register based on the crap passed
+# in. The upper 8 bits (0 - 7) are read only and will be used as flags to con-
+# trol what we are doing:
+#
+*pllcPLL0_DO_CFG=	\0x80000000;	# PLL0 configuration is valid
+*pllcPLL0_DO_RNG=	\0x40000000;	# PLL0 range is valid
+*pllcPLL1_DO_CFG=	\0x20000000;	# PLL1 configuration is valid
+*pllcPLL1_DO_RNG=	\0x10000000;	# PLL1 range is valid
+*pllcPLL_DO_SEL=	\0x08000000;	# PLL select is valid
+#*pllcPLL0_DO_CONTROL=	\0x04000000;	# PLL0 control is valid
+
+#*pllcPLL0_CONTROL_MASK=	\0x20000;
+*pllcPLL_SEL_MASK=	\0x10000;
+#*pllcPLL0_CFG_MASK=	\0x0f800;
+*pllcPLL0_CFG_SHIFT=	\11;
+#*pllcPLL0_RNG_MASK=	\0x00600;
+*pllcPLL0_RNG_SHIFT=	\9;
+#*pllcPLL1_CFG_MASK=	\0x000f8;
+*pllcPLL1_CFG_SHIFT=	\3;
+#*pllcPLL1_RNG_MASK=	\0x00006;
+*pllcPLL1_RNG_SHIFT=	\1;
+
+sub plliCommaize
+{
+my ($num) = @_;
+
+	1 while $num =~ s/(\d)(\d\d\d)(?!\d)/$1,$2/;
+
+	return $num;
+}
+
+sub plliGetActivePLL
+{
+my ($pll) = @_;
+
+	#
+	# Put PSTAT1 (bit 7 by IBM numbering) into the LSBit position.
+	#
+	$pll = $pll >> 24;
+	$pll = $pll & 0x1;
+
+	return $pll;
+}
+
+sub plliGetPLLRatio
+{
+my ($ratio,$config) = @_;
+
+	#
+	# Turn ratio into a right shift count. 0 -> 11, 1 -> 3
+	#
+	$ratio = ($ratio & 0x1) ^ 1;
+	$ratio = $ratio << 3;
+	$ratio = $ratio + 3;
+
+	$config = $config >> $ratio;
+	$config = $config & 0x1F;
+
+	return $config;
+}
+
+sub plliGetPLLRange
+{
+my ($range,$config) = @_;
+
+	#
+	# Turn range into a right shift count. 0 -> 9, 1 -> 1
+	#
+	$range = ($range & 0x1) ^ 1;
+	$range = $range << 3;
+	$range = $range + 1;
+
+	$config = $config >> $range;
+	$config = $config & 0x3;
+
+	return $config;
+}
+
+sub plliPLLOff
+{
+my ($pll_ratio) = @_;
+
+	return $pll_ratio==0 || $pll_ratio==1 || $pll_ratio==31 ||
+		$pll_ratio==2 || $pll_ratio==3;
+}
+
+sub plliGetBusFreq
+{
+my ($sfile) = @_;
+
+my $open_status;
+my $byte_count;
+my $bus_freq;
+my $bus_freq_unpacked;
+
+	#
+	# Get bus clock frequency. Get this from the root of the device tree in
+	# /proc in the "clock-frequency" property of the root node.
+	#
+	$byte_count=0;
+
+	$open_status=open FH,"<",$sfile;
+	if(!defined $open_status) {die "Can't open $sfile.\n";}
+
+	binmode FH,":raw";
+	$byte_count=read FH, $bus_freq, 4;
+	close FH;
+
+	#
+	# Convert binary in bus_freq to normal perl value
+	#
+	$bus_freq_unpacked=unpack "N",$bus_freq;
+
+	return $bus_freq_unpacked;
+}
+
+sub plliGetPVR
+{
+my ($sfile) = @_;
+
+my $cpu_pvr;
+my $cpu_pvr_unpacked;
+my $processor_version;
+my @pvr_list;
+my $byte_count;
+my $open_status;
+my @out;
+
+	@out=();
+
+	#
+	# Get processor pvr. It can be found in cpu-version property of the
+	# "PowerPC,*" directory.
+	#
+	$byte_count=0;
+	@pvr_list=();
+	@pvr_list=glob $sfile;
+
+	$open_status=open FH,"<",$pvr_list[0];
+	if(!defined $open_status) {die "Can't open $pvr_list[0].\n";}
+
+	binmode FH,":raw";
+	$byte_count=read FH, $cpu_pvr, 4;
+	close FH;
+
+	#
+	# Convert binary in cpu_pvr to normal perl value
+	#
+	$cpu_pvr_unpacked=unpack "N",$cpu_pvr;
+	$processor_version=unpack "n",$cpu_pvr;
+
+	#
+	# Put pvr in index 0, version in 1, globbed file name in 2.
+	#
+	push @out,unpack "N",$cpu_pvr;
+	push @out,unpack "n",$cpu_pvr;
+	push @out,$pvr_list[0];
+
+	return wantarray ? @out:$out[0];
+}
+
+sub plliGetPLL
+{
+my ($sfile) = @_;
+
+my $byte_count;
+my $open_status;
+my @pll_list;
+my $pll;
+my @out;
+
+	@out=();
+
+	#
+	# Get value of pll. It is in /sys/devices/system/cpu/cpu0/ppc750gxpll
+	#
+	$byte_count=0;
+	@pll_list=();
+	@pll_list=glob $sfile;
+
+	$open_status=open FH,"<",$pll_list[0];
+	if(!defined $open_status) {die "Can't open $pll_list[0].\n";}
+
+	#
+	# Currently, this is ascii.
+	#
+	$pll=<FH>;
+	close FH;
+
+	chop $pll;
+
+	#
+	# Stick pll (in ascii?) in element 0. Put globbed file name in 1.
+	#
+	push @out,$pll;
+	push @out,$pll_list[0];
+
+	return wantarray ? @out:$out[0];
+}
+
+sub plliSetPLL
+{
+my ($sfile,$pll) = @_;
+
+my $byte_count;
+my $open_status;
+my @pll_list;
+
+	#
+	# Set value of pll. It is in /sys/devices/system/cpu/cpu0/ppc750gxpll
+	#
+	$byte_count=0;
+	@pll_list=();
+	@pll_list=glob $sfile;
+
+	$open_status=open FH,">",$pll_list[0];
+	if(!defined $open_status) {die "Can't open $pll_list[0].\n";}
+
+	printf FH "%x",$pll;
+	close FH;
+}
+
+sub plliAsciiizePLL
+{
+my ($pll,$bus_clk,$sfile,$verbose) = @_;
+my @range_string = ("default","high","low","reserved");
+my @fmt_list = ("off","bypass","%d","%d.5");
+#
+# This mess represents a 32 element array of 2 bit values to turn the ratio
+# into one of the above format strings.
+#
+my @ratio_fmt = (0xEEEEEE50,0x2AAAAAEE);
+my $temp0;
+my $i;
+my $j;
+my $rat0_ext;
+my $rng0_ext;
+my $pll0_cfg_ext;
+my $rat0;
+my $rng0;
+my $pll0_cfg;
+my $rat1;
+my $rng1;
+my $pll1_cfg;
+my @out;
+
+	@out=();
+
+	$pll=hex $pll;
+
+	#
+	# PCE, bits [0-4]
+	#
+	$temp0=$pll>>27;
+	$temp0=$temp0&0x1F;
+
+	if($temp0>15)
+	{
+		$i=$temp0-16;
+		$j=$ratio_fmt[1];
+	}
+	else
+	{
+		$i=$temp0;
+		$j=$ratio_fmt[0];
+	}
+
+	$rng0=($j>>($i<<1))&0x3;
+
+	if($temp0>20) {$temp0=($temp0-10)<<1;}
+	$rat0_ext=$temp0;
+
+	$pll0_cfg_ext=sprintf $fmt_list[$rng0],$rat0_ext>>1;
+	#
+	# PRE, bits [5-6]
+	#
+	$rng0_ext=($pll>>25)&0x3;
+	#
+	# PC0, bits [16-20]
+	#
+	$temp0=plliGetPLLRatio(0,$pll);
+
+	if($temp0>15)
+	{
+		$i=$temp0-16;
+		$j=$ratio_fmt[1];
+	}
+	else
+	{
+		$i=$temp0;
+		$j=$ratio_fmt[0];
+	}
+
+	$rng0=($j>>($i<<1))&0x3;
+
+	if($temp0>20) {$temp0=($temp0-10)<<1;}
+	$rat0=$temp0;
+
+	$pll0_cfg=sprintf $fmt_list[$rng0],$rat0>>1;
+	#
+	# PR0, bits [21-22]
+	#
+	$rng0=plliGetPLLRange(0,$pll);
+	#
+	# PC1, bits [24-28]
+	#
+	$temp0=plliGetPLLRatio(1,$pll);
+
+	if($temp0>15)
+	{
+		$i=$temp0-16;
+		$j=$ratio_fmt[1];
+	}
+	else
+	{
+		$i=$temp0;
+		$j=$ratio_fmt[0];
+	}
+
+	$rng1=($j>>($i<<1))&0x3;
+
+	if($temp0>20) {$temp0=($temp0-10)<<1;}
+	$rat1=$temp0;
+
+	$pll1_cfg=sprintf $fmt_list[$rng1],$rat1>>1;
+	#
+	# PR1, bits [29-30]
+	#
+	$rng1=plliGetPLLRange(1,$pll);
+
+	push @out,sprintf "0x%08x:  ",$pll;
+	push @out,sprintf "PLL0 external (%s (%s MHz), %s), ",$pll0_cfg_ext,
+		plliCommaize($rat0_ext*$bus_clk/2000000),
+		$range_string[$rng0_ext];
+	push @out,sprintf "PLL %d selected, ",plliGetActivePLL($pll);
+	push @out,sprintf "PLL0 %s, ",($pll>>17)&0x1?"internal":"external";
+	push @out,sprintf "PLL0 (%s (%s MHz), %s), ",$pll0_cfg,
+		plliCommaize($rat0*$bus_clk/2000000),$range_string[$rng0];
+	push @out,sprintf "PLL1 (%s (%s MHz), %s)",$pll1_cfg,
+		plliCommaize($rat1*$bus_clk/2000000),$range_string[$rng1];
+
+	if($verbose)
+	{
+		push @out,sprintf "\n\tFrom file %s.",$sfile;
+	}
+
+#	return wantarray ? @out:$out[0];
+	return @out;
+}
+
+sub plliPrintHelp
+{
+	printf "%s:  [ -bdhtv ] [ -f { clk | ratio }] [ -p pll ] [ -s pll ]\n",
+		$0;
+	printf "\tb:\tprint bus frequency\n";
+	printf "\td:\tdump current pll configuration\n";
+	printf "\tf:\tset frequency to specified clk (MHz) or ratio (r suffix)";
+	printf "\n";
+	printf "\tp:\tuse specified pll (0 or 1)\n";
+	printf "\ts:\tswitch to selected pll (0 or 1)\n";
+	printf "\tt:\ttoggle selected pll. Use with -f to cause a switch to ".
+		"the newly\n\t\tmodified PLL on lock.\n";
+	printf "\tv:\tenable verbose\n";
+}
+
+sub plliPrintBusFreq
+{
+my ($bus_freq,$sfile,$verbose) = @_;
+
+	if($bus_freq>1000000) {$bus_freq=$bus_freq/1000000;}
+
+	$bus_freq=plliCommaize $bus_freq;
+
+	print "System Bus Frequency is $bus_freq MHz.\n";
+	print "\tFrom $sfile.\n" if $verbose;
+}
+
+sub plliTogglePLL
+{
+my ($sfile,$bus_freq,$verbose) = @_;
+
+my @pll;
+my $pll;
+my $active_pll;
+my $active_ratio;
+my $other_pll;
+my $other_ratio;
+my $set_pll;
+
+	@pll=plliGetPLL($sfile);
+	$pll=hex $pll[0];
+
+	$active_pll=plliGetActivePLL($pll);
+	$active_ratio=plliGetPLLRatio $active_pll,$pll;
+
+	#
+	# Make sure the "other" pll is active
+	#
+	$other_pll=$active_pll^1;
+	$other_ratio=plliGetPLLRatio $other_pll,$pll;
+printf "active %d, other %d\n",$active_ratio,$other_ratio;
+
+	if(plliPLLOff($other_ratio))
+	{
+		printf "\"Other\" PLL %d (%d) is off. Can't switch to it.\n",
+			$other_pll,$other_ratio;
+	}
+	else
+	{
+		$set_pll=$pllcPLL_DO_SEL;
+		if($other_pll==1) {$set_pll=$set_pll|$pllcPLL_SEL_MASK;}
+
+
+		if($verbose)
+		{
+			if($active_ratio>20) {$active_ratio=($active_ratio-10)
+				<<1;}
+			if($other_ratio>20) {$other_ratio=($other_ratio-10)
+				<<1;}
+			printf "Switching from PLL %d (%d:  %s MHz) to PLL %d",
+				$active_pll,$active_ratio,plliCommaize(
+				$active_ratio*$bus_freq/2000000),$other_pll;
+			printf " (%d:  %s MHz)\n",$other_ratio,plliCommaize(
+				$other_ratio*$bus_freq/2000000);
+		}
+
+		plliSetPLL $sfile,$set_pll;
+	}
+}
+
+sub plliSetFreq
+{
+my ($sfile,$freq_arg,$pll_num,$pll_set,$bus_freq,$verbose) = @_;
+
+my @pll;
+my $pll;
+my $active_pll;
+my $active_ratio;
+my $set_pll;
+my $new_rat;
+my $new_cfg;
+my $new_rng;
+my $temp;
+my $computed_freq;
+my $cfg_shift;
+my $rng_shift;
+my $freq_copy;
+
+	@pll=plliGetPLL($sfile);
+	$pll=hex $pll[0];
+	$freq_copy=$freq_arg;
+
+	$active_pll=plliGetActivePLL($pll);
+	$active_ratio=plliGetPLLRatio $active_pll,$pll;
+
+	#
+	# Figure out which PLL to use. If the number is passed in via $pll_num,
+	# make sure it is not the active PLL.
+	#
+	if(defined $pll_num)
+	{
+		if($pll_num!=0 && $pll_num!=1)
+		{
+			die sprintf "Specified PLL must be 0 or 1 (%d)\n",
+				$pll_num;
+		}
+
+		if($pll_num==$active_pll)
+		{
+			die sprintf "Can't change active PLL (%d)\n",$pll_num;
+		}
+	}
+	else {$pll_num=$active_pll^1;}
+
+	#
+	# Now analyze the frequency argument. There are three possible formats:
+	#	  i) a straight number is taken as a MHz value
+	#	 ii) a number followed by an 'r' (or 'R') to be used as a ratio
+	#	iii) the string 'off' to turn the PLL off
+	#
+	if($freq_copy eq "off") {$new_rat=0;}
+	elsif($freq_copy=~/([\d]+)[rR]/)
+	{
+		$new_rat=$1;
+
+		#
+		# Check the range of values. Legal values are [2-20]. Have no
+		# idea which are legal for the core at the given bus frequency.
+		#
+		if($new_rat<2 || $new_rat>20)
+		{
+			die sprintf "Specified ratio (%d) is out of range\n",
+				$new_rat;
+		}
+	}
+	elsif($freq_copy=~/([\d]+)/)
+	{
+		#
+		# Multiply by 2 to support the half ratios
+		#
+		$new_rat=$1*2000000;
+
+		#
+		# Convert frequency to ratio by dividing by $bus_freq. Then
+		# make sure the given ratio is within the legal range. (Don't
+		# know if it is valid for the core.). Keep in mind that it is
+		# doubled from above ( x 2,000,000 instead of x 1,000,000). So
+		# instead of 2 and 20 the ratio limits are 4 and 40.
+		#
+		$temp=$new_rat/$bus_freq;
+		if($temp<4 || $temp>40)
+		{
+			die sprintf "Specified frequency (%d) results in ratio".
+				" (%d) that is out of range\n",$new_rat,$temp;
+		}
+
+		$new_rat=$temp;
+	}
+	else
+	{
+		die sprintf "Can't parse frequency argument (%s)\n",$freq_arg;
+	}
+
+	#
+	# First convert actual bus ratio to CFG specific value. From 2 to 10
+	# just double it. From 11 to 20 add 10.
+#	if($temp0>20) {$temp0=($temp0-10)<<1;}
+#	if($new_rat<11) {$new_cfg=$new_rat<<1;}
+#	else {$new_cfg=$new_rat+10;}
+	#
+	# new_rat is already doubled from above, so the above becomes
+	#
+	if($new_rat<22) {$new_cfg=$new_rat;}
+	else {$new_cfg=($new_rat>>1)+10;}
+
+	#
+	# Now set the range. I don't know what to do with this? Not sure what
+	# the correct values are for 600,000,000 and 900,000,000 (See table 5-1
+	# in 750GX data sheet).
+	#
+	$computed_freq=($bus_freq*$new_rat)>>1;
+	if($computed_freq<600000000) {$new_rng=2;}
+	elsif($computed_freq<900000000) {$new_rng=0;}
+	else {$new_rng=1;}
+
+	if($pll_num==0)
+	{
+		$cfg_shift=$pllcPLL0_CFG_SHIFT;
+		$rng_shift=$pllcPLL0_RNG_SHIFT;
+		$set_pll=$pllcPLL0_DO_CFG|$pllcPLL0_DO_RNG;
+	}
+	else
+	{
+		$cfg_shift=$pllcPLL1_CFG_SHIFT;
+		$rng_shift=$pllcPLL1_RNG_SHIFT;
+		$set_pll=$pllcPLL1_DO_CFG|$pllcPLL1_DO_RNG;
+	}
+
+	$set_pll=$set_pll|($new_cfg<<$cfg_shift)|($new_rng<<$rng_shift);
+
+	#
+	# If the pll_set argument is defined, then also encode a PLL change to
+	# the new PLL
+	#
+	if(defined $pll_set && $freq_arg ne "off")
+	{
+		$set_pll=$set_pll|$pllcPLL_DO_SEL;
+
+		if($pll_num==1) {$set_pll=$set_pll|$pllcPLL_SEL_MASK;}
+	}
+
+	if($verbose)
+	{
+		if($freq_arg eq "off")
+		{
+			printf "Turning PLL %d off\n",$pll_num;
+		}
+		else
+		{
+			printf "Setting PLL %d to %s MHz (%d)\n",$pll_num,
+				plliCommaize($computed_freq/1000000),$new_cfg;
+		}
+
+		if(defined $pll_set && $freq_arg ne "off")
+		{
+			printf "\tAlso switching to the newly modified PLL\n";
+		}
+
+		printf "Assembled PLL command is 0x%x\n",$set_pll;
+	}
+
+	plliSetPLL $sfile,$set_pll;
+}
+
+our ($opt_o, $opt_i, $opt_f);
+our %pllgOptHash;
+my $pllgBusFreq;
+my $pllgVerbose;
+my @pvr;
+my @pll;
+
+$pllgVerbose=0;
+
+getopts("bdf:hp:s:tv",\%pllgOptHash);
+
+if(defined $pllgOptHash{h} && $pllgOptHash{h}==1) {plliPrintHelp;}
+
+if(defined $pllgOptHash{v} && $pllgOptHash{v}==1) {$pllgVerbose=1;}
+
+#@pvr=plliGetPVR $pllcCPUPVR;
+#printf "Printed output from plliGetPVR() is %x.\n",plliGetPVR($pllcCPUPVR);
+#printf "CPU PVR from \"%s\" is %8x\n",$pvr[2],$pvr[0];
+#printf "CPU Version is %4x\n",$pvr[1];
+
+$pllgBusFreq=plliGetBusFreq $pllcBusFreqFile;
+
+@pll=plliGetPLL $pllcSysFS;
+
+if(defined $pllgOptHash{d} && $pllgOptHash{d}==1)
+{
+	print plliAsciiizePLL($pll[0],$pllgBusFreq,$pll[1],$pllgVerbose),"\n";
+
+	#
+	# Only do -d once if we aren't changing the PLL
+	#
+	if(!defined $pllgOptHash{t} && !defined $pllgOptHash{f} && !defined
+		$pllgOptHash{s}) {exit;}
+}
+
+if(defined $pllgOptHash{b} && $pllgOptHash{b}==1) {plliPrintBusFreq
+	$pllgBusFreq,$pllcBusFreqFile,$pllgVerbose;}
+
+if(defined $pllgOptHash{t} && $pllgOptHash{t}==1 && !defined $pllgOptHash{f})
+	{plliTogglePLL $pllcSysFS,$pllgBusFreq,$pllgVerbose;}
+
+if(defined $pllgOptHash{f}) {plliSetFreq $pllcSysFS,$pllgOptHash{f},
+	,$pllgOptHash{p},$pllgOptHash{t},$pllgBusFreq,$pllgVerbose;}
+
+@pll=plliGetPLL $pllcSysFS;
+
+if(defined $pllgOptHash{d} && $pllgOptHash{d}==1) {print plliAsciiizePLL(
+	$pll[0],$pllgBusFreq,$pll[1],$pllgVerbose),"\n";}
+
+exit;
