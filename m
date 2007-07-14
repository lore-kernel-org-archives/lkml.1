Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbXGNRGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbXGNRGz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 13:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbXGNRGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 13:06:48 -0400
Received: from smtp-out1.libero.it ([212.52.84.41]:40107 "EHLO
	smtp-out1.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667AbXGNRGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 13:06:46 -0400
X-Scanned: with antispam and antivirus automated system at libero.it
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAANKfmEbAqBEE/2dsb2JhbAAN
Date: Sat, 14 Jul 2007 19:06:44 +0200
Message-Id: <JL6I78$882697E50137651823FA4B2DE7CA203F@libero.it>
Subject: i2c: pca954x I2C mux driver
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
From: "roa\@libero\.it" <roa@libero.it>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
X-XaM3-API-Version: 4.3 (R1) (B3pl19)
X-SenderIP: 83.211.64.233
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First of all excuse me for my bad english, this is my first time in LKML.

I'm not a programmer, but i'm a Gygabyte 7DPXDW+ owner (thanks ebay...), then i tried to compile a 2.6.20 patched kernel with an adapted version of the Kumar Gala's code as i found in:

http://lkml.org/lkml/2006/3/30/379
http://lkml.org/lkml/2006/3/30/385
http://lkml.org/lkml/2006/4/25/211

Well, the modified patch end related fixes applies well and compile, i get the pca954x module to work with:

modprobe pca954xx force_pca9540=0,0x70

the dmesg command says:

i2c-5: Virtual I2C bus (Physical bus i2c-0, multiplexer 0x70 port 0)
i2c-6: Virtual I2C bus (Physical bus i2c-0, multiplexer 0x70 port 1)
pca954x 0-0070: Registered 2 virtual buses for I2C mux pca9540

and the i2cdetect says:

  Installed I2C busses:
    i2c-6       smbus           Virtual I2C (i2c-0, mux 70:01)
    i2c-5       smbus           Virtual I2C (i2c-0, mux 70:00)
    i2c-0       smbus           SMBus AMD768 adapter at 50e0
    i2c-4       i2c             NVIDIA I2C Device
    i2c-3       i2c             NVIDIA I2C Device
    i2c-2       i2c             NVIDIA I2C Device
    i2c-1       smbus           saa7133[0]

This means that's all ok:), the module works!

Now the problem, the motherboard has two LM90 multiplexed by the PCA9540, but the sensors command only shows one chip directly attached to the amd768 bus:

lm90-i2c-0-4c
Adapter: SMBus AMD768 adapter at 50e0

M/B Temp:    +37°C  (low  =    +0°C, high =   +70°C)
CPU Temp:  +47.5°C  (low  =  +0.0°C, high = +70.0°C)
M/B Crit:    +85°C  (hyst =   +75°C)
CPU Crit:    +80°C  (hyst =   +70°C)

I tried to force the probe of the lm90 module with:

modprobe lm90 force_lm90=5,0x4c

or

modprobe lm90 force_lm90=6,0x4c

but the sensors command only seen the i2c-0 address.

The strange thing is that sensors-detect recognize both the LM90 on the virtual buses (plus one on the real bus):

sensors-detect
# sensors-detect revision 1.413 (2006/01/19 20:28:00)

This program will help you determine which I2C/SMBus modules you need to
load to use lm_sensors most effectively. You need to have i2c and
lm_sensors installed before running this program.
Also, you need to be `root', or at least have access to the /dev/i2c-*
files, for most things.
If you have patched your kernel and have some drivers built in, you can
safely answer NO if asked to load some modules. In this case, things may
seem a bit confusing, but they will still work.

It is generally safe and recommended to accept the default answers to all
questions, unless you know what you're doing.

 We can start with probing for (PCI) I2C or SMBus adapters.
 You do not need any special privileges for this.
 Do you want to probe now? (YES/no):
Probing for PCI bus adapters...
Use driver `i2c-amd756' for device 00:07.3: AMD-768 System Management
Probe succesfully concluded.

We will now try to load each adapter module in turn.
Module `i2c-amd756' already loaded.
If you have undetectable or unsupported adapters, you can have them
scanned by manually loading the modules before running this script.

 To continue, we need module `i2c-dev' to be loaded.
 If it is built-in into your kernel, you can safely skip this.
i2c-dev is already loaded.

 We are now going to do the adapter probings. Some adapters may hang halfway
 through; we can't really help that. Also, some chips will be double detected;
 we choose the one with the highest confidence value in that case.
 If you found that the adapter hung after probing a certain address, you can
 specify that address to remain unprobed. That often
 includes address 0x69 (clock chip).

Next adapter: Virtual I2C (i2c-0, mux 70:01)
Do you want to scan it? (YES/no/selectively):
Client found at address 0x08
Client found at address 0x4c
Probing for `National Semiconductor LM75'... Failed!
Probing for `Dallas Semiconductor DS1621'... Failed!
Probing for `Analog Devices ADM1021'... Failed!
Probing for `Analog Devices ADM1021A/ADM1023'... Failed!
Probing for `Maxim MAX1617'... Failed!
Probing for `Maxim MAX1617A'... Failed!
Probing for `TI THMC10'... Failed!
Probing for `National Semiconductor LM84'... Failed!
Probing for `Genesys Logic GL523SM'... Failed!
Probing for `Onsemi MC1066'... Failed!
Probing for `Maxim MAX1619'... Failed!
Probing for `National Semiconductor LM82/LM83'... Failed!
Probing for `National Semiconductor LM90'... Success!
    (confidence 8, driver `lm90')
Probing for `National Semiconductor LM89/LM99'... Failed!
Probing for `National Semiconductor LM86'... Failed!
Probing for `Analog Devices ADM1032'... Failed!
Probing for `Maxim MAX6657/MAX6658/MAX6659'... Failed!
Probing for `National Semiconductor LM63'... Failed!
Probing for `Maxim MAX6633/MAX6634/MAX6635'... Failed!
Probing for `Analog Devices ADT7461'... Failed!
Client found at address 0x50
Probing for `SPD EEPROM'... Success!
    (confidence 8, driver `eeprom')
Probing for `DDC monitor'... Failed!
Probing for `Maxim MAX6900'... Failed!
Client found at address 0x51
Probing for `SPD EEPROM'... Success!
    (confidence 8, driver `eeprom')
Client found at address 0x61
Probing for `SMBus 2.0 ARP-Capable Device'... Success!
    (confidence 1, driver `smbus-arp')
Client found at address 0x69
Client found at address 0x70
Probing for `Philips Semiconductors PCA9540'... Success!
    (confidence 1, driver `pca954x')

Next adapter: Virtual I2C (i2c-0, mux 70:00)
Do you want to scan it? (YES/no/selectively):
Client found at address 0x08
Client found at address 0x4c
Probing for `National Semiconductor LM75'... Failed!
Probing for `Dallas Semiconductor DS1621'... Failed!
Probing for `Analog Devices ADM1021'... Failed!
Probing for `Analog Devices ADM1021A/ADM1023'... Failed!
Probing for `Maxim MAX1617'... Failed!
Probing for `Maxim MAX1617A'... Failed!
Probing for `TI THMC10'... Failed!
Probing for `National Semiconductor LM84'... Failed!
Probing for `Genesys Logic GL523SM'... Failed!
Probing for `Onsemi MC1066'... Failed!
Probing for `Maxim MAX1619'... Failed!
Probing for `National Semiconductor LM82/LM83'... Failed!
Probing for `National Semiconductor LM90'... Success!
    (confidence 8, driver `lm90')
Probing for `National Semiconductor LM89/LM99'... Failed!
Probing for `National Semiconductor LM86'... Failed!
Probing for `Analog Devices ADM1032'... Failed!
Probing for `Maxim MAX6657/MAX6658/MAX6659'... Failed!
Probing for `National Semiconductor LM63'... Failed!
Probing for `Maxim MAX6633/MAX6634/MAX6635'... Failed!
Probing for `Analog Devices ADT7461'... Failed!
Client found at address 0x50
Probing for `SPD EEPROM'... Success!
    (confidence 8, driver `eeprom')
Probing for `DDC monitor'... Failed!
Probing for `Maxim MAX6900'... Failed!
Client found at address 0x51
Probing for `SPD EEPROM'... Success!
    (confidence 8, driver `eeprom')
Client found at address 0x61
Probing for `SMBus 2.0 ARP-Capable Device'... Success!
    (confidence 1, driver `smbus-arp')
Client found at address 0x69
Client found at address 0x70
Probing for `Philips Semiconductors PCA9540'... Success!
    (confidence 1, driver `pca954x')

Next adapter: SMBus AMD768 adapter at 50e0
Do you want to scan it? (YES/no/selectively):
Client found at address 0x08
Client found at address 0x4c
Probing for `National Semiconductor LM75'... Failed!
Probing for `Dallas Semiconductor DS1621'... Failed!
Probing for `Analog Devices ADM1021'... Failed!
Probing for `Analog Devices ADM1021A/ADM1023'... Failed!
Probing for `Maxim MAX1617'... Failed!
Probing for `Maxim MAX1617A'... Failed!
Probing for `TI THMC10'... Failed!
Probing for `National Semiconductor LM84'... Failed!
Probing for `Genesys Logic GL523SM'... Failed!
Probing for `Onsemi MC1066'... Failed!
Probing for `Maxim MAX1619'... Failed!
Probing for `National Semiconductor LM82/LM83'... Failed!
Probing for `National Semiconductor LM90'... Success!
    (confidence 8, driver `lm90')
Probing for `National Semiconductor LM89/LM99'... Failed!
Probing for `National Semiconductor LM86'... Failed!
Probing for `Analog Devices ADM1032'... Failed!
Probing for `Maxim MAX6657/MAX6658/MAX6659'... Failed!
Probing for `National Semiconductor LM63'... Failed!
Probing for `Maxim MAX6633/MAX6634/MAX6635'... Failed!
Probing for `Analog Devices ADT7461'... Failed!
Client found at address 0x50
Probing for `SPD EEPROM'... Success!
    (confidence 8, driver `eeprom')
Probing for `DDC monitor'... Failed!
Probing for `Maxim MAX6900'... Failed!
Client found at address 0x51
Probing for `SPD EEPROM'... Success!
    (confidence 8, driver `eeprom')
Client found at address 0x61
Probing for `SMBus 2.0 ARP-Capable Device'... Success!
    (confidence 1, driver `smbus-arp')
Client found at address 0x69
Client at address 0x70 can not be probed - unload all client drivers first!

Next adapter: NVIDIA I2C Device
Do you want to scan it? (YES/no/selectively):

Next adapter: NVIDIA I2C Device
Do you want to scan it? (YES/no/selectively):

Next adapter: NVIDIA I2C Device
Do you want to scan it? (YES/no/selectively):
Client found at address 0x50
Probing for `SPD EEPROM'... Success!
    (confidence 1, driver `eeprom')
Probing for `DDC monitor'... Success!
    (confidence 8, driver `eeprom'), other addresses: 0x51 0x52 0x53 0x54 0x55 0x56 0x57
Probing for `Maxim MAX6900'... Failed!

Next adapter: saa7133[0]
Do you want to scan it? (YES/no/selectively):
Client found at address 0x08
Client at address 0x4b can not be probed - unload all client drivers first!
Client found at address 0x50
Probing for `SPD EEPROM'... Success!
    (confidence 1, driver `eeprom')
Probing for `DDC monitor'... Failed!
Probing for `Maxim MAX6900'... Failed!

Some chips are also accessible through the ISA bus. ISA probes are
typically a bit more dangerous, as we have to write to I/O ports to do
this. This is usually safe though.

Do you want to scan the ISA bus? (YES/no):
Probing for `National Semiconductor LM78'
  Trying address 0x0290... Failed!
Probing for `National Semiconductor LM78-J'
  Trying address 0x0290... Failed!
Probing for `National Semiconductor LM79'
  Trying address 0x0290... Failed!
Probing for `Winbond W83781D'
  Trying address 0x0290... Failed!
Probing for `Winbond W83782D'
  Trying address 0x0290... Failed!
Probing for `Winbond W83627HF'
  Trying address 0x0290... Success!
    (confidence 8, driver `w83781d')
Probing for `Winbond W83627EHF'
  Trying address 0x0290... Failed!
Probing for `Silicon Integrated Systems SIS5595'
  Trying general detect... Failed!
Probing for `VIA Technologies VT82C686 Integrated Sensors'
  Trying general detect... Failed!
Probing for `VIA Technologies VT8231 Integrated Sensors'
  Trying general detect... Failed!
Probing for `ITE IT8712F'
  Trying address 0x0290... Failed!
Probing for `ITE IT8705F / SiS 950'
  Trying address 0x0290... Failed!
Probing for `IPMI BMC KCS'
  Trying address 0x0ca0... Failed!
Probing for `IPMI BMC SMIC'
  Trying address 0x0ca8... Failed!

Some Super I/O chips may also contain sensors. Super I/O probes are
typically a bit more dangerous, as we have to write to I/O ports to do
this. This is usually safe though.

Do you want to scan for Super I/O sensors? (YES/no):
Probing for `ITE 8702F Super IO Sensors'
  Failed! (0x5217)
Probing for `ITE 8705F Super IO Sensors'
  Failed! (0x5217)
Probing for `ITE 8712F Super IO Sensors'
  Failed! (0x5217)
Probing for `Nat. Semi. PC87351 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87360 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87363 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87364 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87365 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87365 Super IO Voltage Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87365 Super IO Thermal Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87366 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87366 Super IO Voltage Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87366 Super IO Thermal Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87372 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87373 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `Nat. Semi. PC87591 Super IO'
  Failed! (0x52)
Probing for `Nat. Semi. PC87371 Super IO'
  Failed! (0x52)
Probing for `Nat. Semi. PC97371 Super IO'
  Failed! (0x52)
Probing for `Nat. Semi. PC8739x Super IO'
  Failed! (0x52)
Probing for `Nat. Semi. PC8741x Super IO'
  Failed! (0x52)
Probing for `Nat. Semi. PCPC87427 Super IO'
  Failed! (0x52)
Probing for `SMSC 47B27x Super IO Fan Sensors'
  Failed! (0x52)
Probing for `SMSC 47M10x/13x Super IO Fan Sensors'
  Failed! (0x52)
Probing for `SMSC 47M14x Super IO Fan Sensors'
  Failed! (0x52)
Probing for `SMSC 47M15x/192/997 Super IO Fan Sensors'
  Failed! (0x52)
Probing for `SMSC 47S42x Super IO Fan Sensors'
  Failed! (0x52)
Probing for `SMSC 47S45x Super IO Fan Sensors'
  Failed! (0x52)
Probing for `SMSC 47M172 Super IO'
  Failed! (0x52)
Probing for `SMSC LPC47B397-NC Super IO'
  Failed! (0x52)
Probing for `SMSC SCH5307-NS Super IO'
  Failed! (0x52)
Probing for `VT1211 Super IO Sensors'
  Failed! (0x52)
Probing for `Winbond W83627HF Super IO Sensors'
  Success... found at address 0x0290
Probing for `Winbond W83627THF Super IO Sensors'
  Failed! (0x52)
Probing for `Winbond W83637HF Super IO Sensors'
  Failed! (0x52)
Probing for `Winbond W83687THF Super IO Sensors'
  Failed! (0x52)
Probing for `Winbond W83697HF Super IO Sensors'
  Failed! (0x52)
Probing for `Winbond W83697SF/UF Super IO PWM'
  Failed! (0x52)
Probing for `Winbond W83L517D Super IO'
  Failed! (0x52)
Probing for `Fintek F71805F/FG Super IO Sensors'
  Failed! (0x5217)
Probing for `Winbond W83627EHF/EHG Super IO Sensors'
  Failed! (0x5217)

Do you want to scan for secondary Super I/O sensors? (YES/no):
Probing for `ITE 8702F Super IO Sensors'
  Failed! (skipping family)
Probing for `Nat. Semi. PC87351 Super IO Fan Sensors'
  Failed! (skipping family)
Probing for `SMSC 47B27x Super IO Fan Sensors'
  Failed! (skipping family)
Probing for `VT1211 Super IO Sensors'
  Failed! (skipping family)
Probing for `Winbond W83627EHF/EHG Super IO Sensors'
  Failed! (skipping family)

 Now follows a summary of the probes I have just done.
 Just press ENTER to continue:

Driver `lm90' (should be inserted):
  Detects correctly:
  * Bus `Virtual I2C (i2c-0, mux 70:01)'
    Busdriver `UNKNOWN', I2C address 0x4c
    Chip `National Semiconductor LM90' (confidence: 8)
  * Bus `Virtual I2C (i2c-0, mux 70:00)'
    Busdriver `UNKNOWN', I2C address 0x4c
    Chip `National Semiconductor LM90' (confidence: 8)
  * Bus `SMBus AMD768 adapter at 50e0'
    Busdriver `i2c-amd756', I2C address 0x4c
    Chip `National Semiconductor LM90' (confidence: 8)

Driver `eeprom' (should be inserted):
  Detects correctly:
  * Bus `Virtual I2C (i2c-0, mux 70:01)'
    Busdriver `UNKNOWN', I2C address 0x50
    Chip `SPD EEPROM' (confidence: 8)
  * Bus `Virtual I2C (i2c-0, mux 70:01)'
    Busdriver `UNKNOWN', I2C address 0x51
    Chip `SPD EEPROM' (confidence: 8)
  * Bus `Virtual I2C (i2c-0, mux 70:00)'
    Busdriver `UNKNOWN', I2C address 0x50
    Chip `SPD EEPROM' (confidence: 8)
  * Bus `Virtual I2C (i2c-0, mux 70:00)'
    Busdriver `UNKNOWN', I2C address 0x51
    Chip `SPD EEPROM' (confidence: 8)
  * Bus `SMBus AMD768 adapter at 50e0'
    Busdriver `i2c-amd756', I2C address 0x50
    Chip `SPD EEPROM' (confidence: 8)
  * Bus `SMBus AMD768 adapter at 50e0'
    Busdriver `i2c-amd756', I2C address 0x51
    Chip `SPD EEPROM' (confidence: 8)
  * Bus `NVIDIA I2C Device'
    Busdriver `UNKNOWN', I2C address 0x50 (and 0x51 0x52 0x53 0x54 0x55 0x56 0x57)
    Chip `DDC monitor' (confidence: 8)
  * Bus `saa7133[0]'
    Busdriver `UNKNOWN', I2C address 0x50
    Chip `SPD EEPROM' (confidence: 1)

Driver `smbus-arp' (should be inserted):
  Detects correctly:
  * Bus `Virtual I2C (i2c-0, mux 70:01)'
    Busdriver `UNKNOWN', I2C address 0x61
    Chip `SMBus 2.0 ARP-Capable Device' (confidence: 1)
  * Bus `Virtual I2C (i2c-0, mux 70:00)'
    Busdriver `UNKNOWN', I2C address 0x61
    Chip `SMBus 2.0 ARP-Capable Device' (confidence: 1)
  * Bus `SMBus AMD768 adapter at 50e0'
    Busdriver `i2c-amd756', I2C address 0x61
    Chip `SMBus 2.0 ARP-Capable Device' (confidence: 1)

Driver `pca954x' (should be inserted):
  Detects correctly:
  * Bus `Virtual I2C (i2c-0, mux 70:01)'
    Busdriver `UNKNOWN', I2C address 0x70
    Chip `Philips Semiconductors PCA9540' (confidence: 1)
  * Bus `Virtual I2C (i2c-0, mux 70:00)'
    Busdriver `UNKNOWN', I2C address 0x70
    Chip `Philips Semiconductors PCA9540' (confidence: 1)

Driver `w83781d' (may not be inserted):
  Misdetects:
  * ISA bus address 0x0290 (Busdriver `i2c-isa')
    Chip `Winbond W83627HF' (confidence: 8)

Driver `w83627hf' (should be inserted):
  Detects correctly:
  * ISA bus address 0x0290 (Busdriver `i2c-isa')
    Chip `Winbond W83627HF Super IO Sensors' (confidence: 9)


I will now generate the commands needed to load the I2C modules.

To make the sensors modules behave correctly, add these lines to
/etc/modprobe.conf:

#----cut here----
# I2C module options
alias char-major-89 i2c-dev
#----cut here----

To load everything that is needed, add this to some /etc/rc* file:

#----cut here----
# I2C adapter drivers
# modprobe unknown adapter saa7133[0]
# modprobe unknown adapter NVIDIA I2C Device
# modprobe unknown adapter NVIDIA I2C Device
# modprobe unknown adapter NVIDIA I2C Device
# modprobe unknown adapter Virtual I2C (i2c-0, mux 70:00)
# modprobe unknown adapter Virtual I2C (i2c-0, mux 70:01)
modprobe i2c-amd756
modprobe i2c-isa
# I2C chip drivers
modprobe lm90
modprobe eeprom
# Warning: the required module smbus-arp is not currently installed on your system.
# For status of 2.6 kernel ports see http://secure.netroedge.com/~lm78/supported.html
# If driver is built-in to the kernel, or unavailable, comment out the following line.
modprobe smbus-arp
modprobe pca954x
modprobe w83627hf
# sleep 2 # optional
/usr/bin/sensors -s # recommended
#----cut here----

WARNING! If you have some things built into your kernel, the list above
will contain too many modules. Skip the appropriate ones! You really should
try these commands right now to make sure everything is working properly.
Monitoring programs won't work until it's done.


, and the i2cdetect -y [bus] says:

bus 0:

i2cdetect -y 0
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          XX XX XX XX XX 08 XX XX XX XX XX XX XX
10: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
20: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
30: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
40: XX XX XX XX XX XX XX XX XX XX XX XX UU XX XX XX
50: UU UU XX XX XX XX XX XX XX XX XX XX XX XX XX XX
60: XX 61 XX XX XX XX XX XX XX 69 XX XX XX XX XX XX
70: UU XX XX XX XX XX XX XX

bus 5:

i2cdetect -y 5
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          XX XX XX XX XX 08 XX XX XX XX XX XX XX
10: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
20: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
30: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
40: XX XX XX XX XX XX XX XX XX XX XX XX 4c XX XX XX
50: UU UU XX XX XX XX XX XX XX XX XX XX XX XX XX XX
60: XX 61 XX XX XX XX XX XX XX 69 XX XX XX XX XX XX
70: 70 XX XX XX XX XX XX XX

bus 6:

i2cdetect -y 6
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          XX XX XX XX XX 08 XX XX XX XX XX XX XX
10: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
20: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
30: XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX
40: XX XX XX XX XX XX XX XX XX XX XX XX 4c XX XX XX
50: UU UU XX XX XX XX XX XX XX XX XX XX XX XX XX XX
60: XX 61 XX XX XX XX XX XX XX 69 XX XX XX XX XX XX
70: 70 XX XX XX XX XX XX XX

Then i think it's all right, both 4c addresses are on virtual buses (on the phisical one there are a UU statement) but a:

sensors *-i2c-5-*

or:

sensors *-i2c-6-*

results in:

No sensors found!

I read that this drive is able to determine if a device is attached to the virtual or the phisical bus and manage to not activate the first one to avoid duplicates, is that true? Is there a way to force the devices attached to the virtual bus to work? Or simply i made a mistake?

Thank for the patience and a big thank for your work.



------------------------------------------------------
Scegli infostrada: ADSL gratis per tutta l’estate e telefoni senza canone Telecom
http://click.libero.it/infostrada

