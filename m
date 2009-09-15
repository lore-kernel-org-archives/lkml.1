Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbZIOVuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbZIOVuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbZIOVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:49:57 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:33533 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbZIOVt4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:49:56 -0400
Date: Tue, 15 Sep 2009 17:49:59 -0400
To: linux-kernel@vger.kernel.org
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org
Subject: free_initrd_mem() corrups mm state on m68knommu.
Message-ID: <20090915214959.GB23702@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been trying to solve a problem I keep seeing on m68knommu (on a
coldfire 5271).

I get:
[42949397.330000] BUG: failure at mm/page_alloc.c:426/page_is_buddy()!
[42949397.330000] Kernel panic - not syncing: BUG!

The page_count is checked and should be 0, but is in fact 1 in this case.

I am booting with an initramfs and using that as root.

If I pass 'retain_initrd' then there is no problem (but I loose about
1MB of the 8MB of ram which isn't great).  If I use nfsroot, then
there also is no issue.  It seems that the memory that is returned by
free_initrd_mem on m68knommu is somehow not correctly initialized and
breaks the system as soon is it is used.

I don't know if the bootloader isn't reserving memory for the initrd
correctly, or if it isn't freed properly or what the issue is.  All I
can tell so far is that not freeing the initrd memory back to the system
makes the problem go away (instead of failing in the first 15 seconds,
I have run for days without issue when not freeing).

Of course none of the existing m68knommu targets seem to actually use
an initrd, so I have no doubt that it hasn't had much testing lately.

I have tried with a git tree checked out last friday, and it has the
same behaviour.

Here is the boot messages with some extra debuging thrown in:

## Booting kernel from Legacy Image at 00200000 ...                       
   Image Name:   uImage                                                   
   Created:      2009-09-15  21:24:56 UTC                                 
   Image Type:   M68K Linux Multi-File Image (uncompressed)               
   Data Size:    2938380 Bytes =  2.8 MB                                  
   Load Address: 00020000                                                 
   Entry Point:  00020000                                                 
   Contents:                                                              
      Image 0: 1728512 Bytes =  1.6 MB                                    
      Image 1: 1209856 Bytes =  1.2 MB                                    
   Verifying Checksum ... OK                                              
## Loading init Ramdisk from multi component Legacy Image at 00200000 ... 
   Loading Multi-File Image ... OK                                        
OK                                                                        
   Loading Ramdisk to 0065b000, end 00782600 ... OK                       
[    0.000000] Linux version 2.6.29.1 (root@rceng02) (gcc version 4.3.3 (GCC) ) #19 Tue Sep 15 17:26:03 EDT 2009
[    0.000000] initrd at 0x65b000:0x782600                                                                      
[    0.000000]                                                                                                  
[    0.000000]                                                                                                  
[    0.000000] uClinux/COLDFIRE(m5270/5271)                                                                     
[    0.000000] COLDFIRE port done by Greg Ungerer, gerg@snapgear.com                                            
[    0.000000] Flat model support (C) 1998,1999 Kenneth Albanowski, D. Jeff Dionne                              
[    0.000000] free_bootmem(1d7000, 629000)reserve_bootmem(1d7000, 100, BOOTMEM_DEFAULT)<7>On node 0 totalpages: 2048
[    0.000000] Built 1 zonelists in Zone order, mobility grouping off.  Total pages: 2032                            
[    0.000000] Kernel command line: rdinit=/sbin/init ip=169.254.72.5:169.254.72.4::255.255.255.0:::off ubootver=2009.06RR8 rdinit=/usr/share/bist/init system mtdparts=physmap-flash.0:256k(uboot),8064k(p01),8064k(p02),-(free)
[    0.000000] PID hash table entries: 32 (order: 5, 128 bytes)                                                                                                                                                                  
[42949372.960000] Dentry cache hash table entries: 1024 (order: 0, 4096 bytes)                                                                                                                                                   
[42949372.960000] Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)                                                                                                                                                    
[42949372.960000] Memory available: 6220k/8192k RAM, (1535k kernel code, 218k data)                                                                                                                                              
[42949372.960000] Calibrating delay loop... 98.71 BogoMIPS (lpj=493568)                                                                                                                                                          
[42949373.160000] Mount-cache hash table entries: 512                                                                                                                                                                            
[42949373.290000] net_namespace: 296 bytes                                                                                                                                                                                       
[42949373.290000] NET: Registered protocol family 16                                                                                                                                                                             
[42949373.320000] bio: create slab <bio-0> at 0                                                                                                                                                                                  
[42949373.340000] NET: Registered protocol family 2                                                                                                                                                                              
[42949373.340000] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)                                                                                                                                                 
[42949373.350000] TCP established hash table entries: 512 (order: 0, 4096 bytes)                                                                                                                                                 
[42949373.350000] TCP bind hash table entries: 512 (order: -1, 2048 bytes)                                                                                                                                                       
[42949373.350000] TCP: Hash tables configured (established 512 bind 512)                                                                                                                                                         
[42949373.350000] TCP reno registered                                                                                                                                                                                            
[42949373.350000] NET: Registered protocol family 1                                                                                                                                                                              
[42949373.360000] checking if image is initramfs... it is
[42949373.820000] Freed initrd memory: <5>65b000 <5>65c000 <5>65d000 <5>65e000 <5>65f000 <5>660000 <5>661000 <5>662000 <5>663000 <5>664000 <5>665000 <5>666000 <5>667000 <5>668000 <5>669000 <5>66a000 <5>66b000 <5>66c000 <5>66d000 <5>66e000 <5>66f000 <5>670000 <5>671000 <5>672000 <5>673000 <5>674000 <5>675000 <5>676000 <5>677000 <5>678000 <5>679000 <5>67a000 <5>67b000 <5>67c000 <5>67d000 <5>67e000 <5>67f000 <5>680000 <5>681000 <5>682000 <5>683000 <5>684000 <5>685000 <5>686000 <5>687000 <5>688000 <5>689000 <5>68a000 <5>68b000 <5>68c000 <5>68d000 <5>68e000 <5>68f000 <5>690000 <5>691000 <5>692000 <5>693000 <5>694000 <5>695000 <5>696000 <5>697000 <5>698000 <5>699000 <5>69a000 <5>69b000 <5>69c000 <5>69d000 <5>69e000 <5>69f000 <5>6a0000 <5>6a1000 <5>6a2000 <5>6a3000 <5>6a4000 <5>6a5000 <5>6a6000 <5>6a7000 <5>6a8000 <5>6a9000 <5>6aa000 <5>6ab000 <5>6ac000 <5>6ad000 <5>6ae000 <5>6af000 <5>6b0000 <5>6b1000 <5>6b2000 <5>6b3000 <5>6b4000 <5>6b5000 <5>6b6000 <5>6b7000 <5>6b8000 <5>6b9000 <5>6ba000 <5>6bb000 <5>6bc000 <5>6bd000 <5>6be000 <5>6bf000 <5>6c0000 <5>6c1000 <5>6c2000 <5>6c3000 <5>6c4000 <5>6c5000 <5>6c6000 <5>6c7000 <5>6c8000 <5>6c9000 <5>6ca000 <5>6cb000 <5>6cc000 <5>6cd000 <5>6ce000 <5>6cf000 <5>6d0000 <5>6d1000 <5>6d2000 <5>6d3000 <5>6d4000 <5>6d5000 <5>6d6000 <5>6d7000 <5>6d8000 <5>6d9000 <5>6da000 <5>6db000 <5>6dc000 <5>6dd000 <5>6de000 <5>6df000 <5>6e0000 <5>6e1000 <5>6e2000 <5>6e3000 <5>6e4000 <5>6e5000 <5>6e6000 <5>6e7000 <5>6e8000 <5>6e9000 <5>6ea000 <5>6eb000 <5>6ec000 <5>6ed000 <5>6ee000 <5>6ef000 <5>6f0000 <5>6f1000 <5>6f2000 <5>6f3000 <5>6f4000 <5>6f5000 <5>6f6000 <5>6f7000 <5>6f8000 <5>6f9000 <5>6fa000 <5>6fb000 <5>6fc000 <5>6fd000 <5>6fe000 <5>6ff000 <5>700000 <5>701000 <5>702000 <5>703000 <5>704000 <5>705000 <5>706000 <5>707000 <5>708000 <5>709000 <5>70a000 <5>70b000 <5>70c000 <5>70d000 <5>70e000 <5>70f000 <5>710000 <5>711000 <5>712000 <5>713000 <5>714000 <5>715000 <5>716000 <5>717000 <5>718000 <5>719000 <5>71a000 <5>71b000 <5>71c000 <5>71d000 <5>71e000 <5>71f000 <5>720000 <5>721000 <5>722000 !
 <5>723000 <5>724000 <5>725000 <5>726000 <5>727000 <5>728000 <5>729000 <5>72a000 <5>72b000 <5>72c000 <5>72d000 <5>72e000 <5>72f000 <5>730000 <5>731000 <5>732000 <5>733000 <5>734000 <5>735000 <5>736000 <5>737000 <5>738000 <5>739000 <5>73a000 <5>73b000 <5>73c000 <5>73d000 <5>73e000 <5>73f000 <5>740000 <5>741000 <5>742000 <5>743000 <5>744000 <5>745000 <5>746000 <5>747000 <5>748000 <5>749000 <5>74a000 <5>74b000 <5>74c000 <5>74d000 <5>74e000 <5>74f000 <5>750000 <5>751000 <5>752000 <5>753000 <5>754000 <5>755000 <5>756000 <5>757000 <5>758000 <5>759000 <5>75a000 <5>75b000 <5>75c000 <5>75d000 <5>75e000 <5>75f000 <5>760000 <5>761000 <5>762000 <5>763000 <5>764000 <5>765000 <5>766000 <5>767000 <5>768000 <5>769000 <5>76a000 <5>76b000 <5>76c000 <5>76d000 <5>76e000 <5>76f000 <5>770000 <5>771000 <5>772000 <5>773000 <5>774000 <5>775000 <5>776000 <5>777000 <5>778000 <5>779000 <5>77a000 <5>77b000 <5>77c000 <5>77d000 <5>77e000 <5>77f000 <5>780000 <5>781000 <5>782000 <5>
[42949373.850000] Freeing initrd memory: 1180k freed
[42949373.870000] io scheduler noop registered (default)
[42949373.870000] ColdFire internal UART serial driver
[42949373.880000] ttyS0 at MMIO 0x40000280 (irq = 79) is a ColdFire UART
[42949373.880000] console [ttyS0] enabled
[42949373.930000] brd: module loaded
[42949373.960000] loop: module loaded
[42949373.970000] FEC ENET Version 0.2
[42949373.980000] fec: PHY @ 0x1, ID 0x00221613 -- KS8721BL
[42949373.990000] eth0 (): not using net_device_ops yet
[42949374.010000] eth0: ethernet 00:00:00:00:05:01
[42949374.020000] fec: setting up smi chardev
[42949374.030000] physmap platform flash device: 01000000 at ff000000
[42949374.040000] physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
[42949374.050000]  Amd/Fujitsu Extended Query Table at 0x0040
[42949374.060000] physmap-flash.0: CFI does not contain boot bank location. Assuming top.
[42949374.070000] number of CFI chips: 1
[42949374.070000] cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
[42949374.080000] 4 cmdlinepart partitions found on MTD device physmap-flash.0
[42949374.090000] Creating 4 MTD partitions on "physmap-flash.0":
[42949374.100000] 0x000000000000-0x000000040000 : "uboot"
[42949374.110000] 0x000000040000-0x000000820000 : "p01"
[42949374.130000] 0x000000820000-0x000001000000 : "p02"
[42949374.140000] 0x000001000000-0x000001000000 : "free"
[42949374.150000] mtd: partition "free" is out of reach -- disabled
[42949374.160000] i2c /dev entries driver
[42949374.250000] lm75 0-0048: hwmon0: sensor 'lm75'
[42949374.340000] lm75 0-0049: hwmon1: sensor 'lm75'
[42949374.390000] i2c-adapter i2c-0: ltc4215 forced at address 0x4c
[42949374.410000] max6369_wdt: Watchdog Driver
[42949374.420000] TCP cubic registered
[42949374.420000] NET: Registered protocol family 17
[42949374.440000] RPC: Registered udp transport module.
[42949374.450000] RPC: Registered tcp transport module.
[42949374.970000] eth0: config: auto-negotiation off, 100FDX, 100HDX, 10FDX, 10HDX.
[42949376.000000] IP-Config: Complete:
[42949376.010000]      device=eth0, addr=169.254.72.5, mask=255.255.255.0, gw=255.255.255.255,
[42949376.030000]      host=169.254.72.5, domain=, nis-domain=(none),
[42949376.040000]      bootserver=169.254.72.4, rootserver=169.254.72.4, rootpath=
[42949376.060000] Freeing unused kernel memory: 76k freed (0x1b2000 - 0x1c4000)
[42949376.760000] max6369_wdt: timer margin 60 seconds
[42949376.770000] max6369_wdt: keep-alive handler deactivated

COLUMNS=271;LINES=66;export COLUMNS LINES;
type "help" for a list of bist commands..


Starting bist
00:00:04.204   ledthread: setting up fpled gpio with "echo 50 > /sys/class/gpio/export"
00:00:04.325   ledthread: setting up fpled gpio with "echo 52 > /sys/class/gpio/export"
00:00:07.682   eval_tests: found sh script eepromtest
00:00:07.684   platform m68kuclinux_target1 id 0x23212f62 parms "12-86-0005-[0-9][0-9][0-9] 12-86-001[0123]-[0-9][0-9][0-9]", flags "SYSTEM SELF"
00:00:08.297   eval_tests: found sh script lm75test
00:00:08.300   platform m68kuclinux_target1 id 0x23212f62 parms "0-0048/temp1_input 0-0049/temp1_input", flags "SYSTEM SELF"
00:00:18.252   Installing tests
00:00:18.336   Starting pass 1 at Tue Nov 30 00:00:18 UTC 1999
00:00:18.423   About to run "BISTCOUNT=1  ./lm75test 0-0048/temp1_input 0-0049/temp1_input"
00:00:18.431   About to run "BISTCOUNT=1  ./eepromtest 12-86-0005-[0-9][0-9][0-9] 12-86-001[0123]-[0-9][0-9][0-9]"
00:00:18.879   lm75test 0-0048/temp1_input 0-0049/temp1_input: PASS
[42949397.330000] page_count(buddy)=1
[42949397.330000] BUG: failure at mm/page_alloc.c:426/page_is_buddy()!
[42949397.330000] Kernel panic - not syncing: BUG!

-- 
Len Sorensen
